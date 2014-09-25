# distutils: language = c++

cdef class NeuralTM:
    def __cinit__(self, normalization=False, map_input_digits=None, map_output_digits=None, cache_size=0):
        self.thisptr = new c_neuralTM()
        self.thisptr.set_normalization(normalization)
        self.thisptr.set_log_base(10.)
        if type(map_input_digits) is str and len(map_input_digits) == 1:
            self.thisptr.set_map_input_digits((<char *>map_input_digits)[0])
        if type(map_output_digits) is str and len(map_output_digits) == 1:
            self.thisptr.set_map_output_digits((<char *>map_output_digits)[0])
        if cache_size:
            self.thisptr.set_cache(cache_size)

    def read(self, filename):
        self.thisptr.read(filename)
        self.order = self.thisptr.get_order()

    def get_order(self):
        return self.thisptr.get_order()

    def lookup_input_word(self, s):
        return self.thisptr.lookup_input_word(s)
    
    def lookup_output_word(self, s):
        return self.thisptr.lookup_output_word(s)
    
    def lookup_ngram(self, words):
        if len(words) == 0:
            raise ValueError("ngram is empty")
        return self.thisptr.lookup_ngram(words)

    def cache_hit_rate(self):
        return self.thisptr.cache_hit_rate()

    # low-level interface that can be called by other Cython modules
    cdef int c_lookup_input_word(self, char *s):
        cdef string ss
        ss.assign(s)
        return self.thisptr.lookup_input_word(ss)

    cdef int c_lookup_output_word(self, char *s):
        cdef string ss
        ss.assign(s)
        return self.thisptr.lookup_output_word(ss)

    cdef float c_lookup_ngram(self, int *words, int n):
        return self.thisptr.lookup_ngram(words, n)
