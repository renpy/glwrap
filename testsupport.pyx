from __future__ import print_function
from libc.stdio cimport printf

import argparse

from sdl2 cimport *

cdef class SDL:

    cdef SDL_Window *window
    cdef SDL_GLContext glc


    def init(self):
        SDL_Init(SDL_INIT_VIDEO)

    def open_window(self, egl):


        SDL_GL_ResetAttributes()

        SDL_GL_SetAttribute(SDL_GL_RED_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_GREEN_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_BLUE_SIZE, 8);
        SDL_GL_SetAttribute(SDL_GL_ALPHA_SIZE, 8);

        if egl:
            SDL_SetHint("SDL_OPENGL_ES_DRIVER", "1")
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_MAJOR_VERSION, 2);
            SDL_GL_SetAttribute(SDL_GL_CONTEXT_PROFILE_MASK, SDL_GL_CONTEXT_PROFILE_ES)
        else:
            SDL_SetHint("SDL_OPENGL_ES_DRIVER", "0")


        self.window = SDL_CreateWindow("UGUU Test Window", SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 400, 400, SDL_WINDOW_OPENGL)

        if not self.window:
            raise Exception("Creating the window failed.")

        self.glc = SDL_GL_CreateContext(self.window);

        if not self.glc:
            raise Exception("Creating GL context failed.")

    def close_window(self):

        SDL_GL_DeleteContext(self.glc)
        SDL_DestroyWindow(self.window)

    def loop(self):

        cdef SDL_Event event

        SDL_GL_SwapWindow(self.window)

        while SDL_PollEvent(&event):

            if event.type == SDL_QUIT:
                return False

        return True

