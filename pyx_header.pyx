from sdl2 cimport SDL_GL_GetProcAddress

cdef void *find_gl_command(names):

    cdef void *rv = NULL

    for i in names:
        rv = SDL_GL_GetProcAddress(i)
        if rv != NULL:
            return rv

    raise Exception("{} not found.".format(names[0]))


cdef const char *error_function
cdef GLenum error_code

def reset_error():
    global error_function
    error_function = NULL

    global error_code
    error_code = GL_NO_ERROR

reset_error()

def get_error():

    if error_function != NULL:
        return error_function.decode("utf-8"), error_code
    else:
        return None, GL_NO_ERROR

from libc.stdio cimport printf

cdef void check_error(const char *function) nogil:

    global error_function
    global error_code

    cdef GLenum error

    error = real_glGetError()

    if (error_function == NULL) and (error != GL_NO_ERROR):
        error_function = function
        error_code = error

cdef class pointer_wrapper:

    cdef void *ptr

    def __cinit__(self, o):
        ptr = NULL

cdef object proxy_return_string(const GLubyte *s):

    cdef const char *ss = <const char *> s

    if ss:
        return ss
    else:
        return None
