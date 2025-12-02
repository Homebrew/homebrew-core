class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v39.0.1",
      revision: "0163804870a2149c113a31a58da4635f79fc25ec"
  license "Apache-2.0" => { with: "LLVM-exception" }
  head "https://github.com/bytecodealliance/wasmtime.git", branch: "main"

  # Upstream maintains multiple major versions and the "latest" release may be
  # for a lower version, so we have to check multiple releases to identify the
  # highest version.
  livecheck do
    url :stable
    strategy :github_releases
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9dd95e7af322fafe9b634794a6c698e723f56f35531be783f298f9e13138c3d7"
    sha256 cellar: :any,                 arm64_sequoia: "0983b8593562239c01888c3dec296f06162ed7bc13a9fac8d5d5de517e5f5039"
    sha256 cellar: :any,                 arm64_sonoma:  "0ecf35ee56d25415d3737df7056930d6026ab15be1b216b7dbdf41021af666ae"
    sha256 cellar: :any,                 sonoma:        "f4aa8271c1b94c958db6fbbc9ca2fba6924216e9de8bc8b54a75d471ee3669b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "d54663a0a2a810910011279b7d99c5d5aea0f72256eb547081c7b5748e7a31a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a275bae2998031f880b56dca965f086b09a3009a0fc3ba50309bcb806aa1e967"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args, "--profile=fastest-runtime"

    system "cmake", "-S", "crates/c-api", "-B", "build", "-DWASMTIME_FASTEST_RUNTIME=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    generate_completions_from_executable(bin/"wasmtime", "completion")
  end

  test do
    wasm = ["0061736d0100000001070160027f7f017f030201000707010373756d00000a09010700200020016a0b"].pack("H*")
    (testpath/"sum.wasm").write(wasm)
    assert_equal "3\n",
      shell_output("#{bin}/wasmtime --invoke sum #{testpath/"sum.wasm"} 1 2")

    (testpath/"hello.wat").write <<~EOS
      (module
        (func $hello (import "" "hello"))
        (func (export "run") (call $hello))
      )
    EOS

    # Example from https://docs.wasmtime.dev/examples-c-hello-world.html to test C library API,
    # with comments removed for brevity
    (testpath/"hello.c").write <<~C
      #include <assert.h>
      #include <stdio.h>
      #include <stdlib.h>
      #include <wasm.h>
      #include <wasmtime.h>

      static void exit_with_error(const char *message, wasmtime_error_t *error, wasm_trap_t *trap);

      static wasm_trap_t* hello_callback(
          void *env,
          wasmtime_caller_t *caller,
          const wasmtime_val_t *args,
          size_t nargs,
          wasmtime_val_t *results,
          size_t nresults
      ) {
        printf("Calling back...\\n");
        printf("> Hello World!\\n");
        return NULL;
      }

      int main() {
        int ret = 0;
        printf("Initializing...\\n");
        wasm_engine_t *engine = wasm_engine_new();
        assert(engine != NULL);

        wasmtime_store_t *store = wasmtime_store_new(engine, NULL, NULL);
        assert(store != NULL);
        wasmtime_context_t *context = wasmtime_store_context(store);

        FILE* file = fopen("./hello.wat", "r");
        assert(file != NULL);
        fseek(file, 0L, SEEK_END);
        size_t file_size = ftell(file);
        fseek(file, 0L, SEEK_SET);
        wasm_byte_vec_t wat;
        wasm_byte_vec_new_uninitialized(&wat, file_size);
        assert(fread(wat.data, file_size, 1, file) == 1);
        fclose(file);

        wasm_byte_vec_t wasm;
        wasmtime_error_t *error = wasmtime_wat2wasm(wat.data, wat.size, &wasm);
        if (error != NULL)
          exit_with_error("failed to parse wat", error, NULL);
        wasm_byte_vec_delete(&wat);

        printf("Compiling module...\\n");
        wasmtime_module_t *module = NULL;
        error = wasmtime_module_new(engine, (uint8_t*) wasm.data, wasm.size, &module);
        wasm_byte_vec_delete(&wasm);
        if (error != NULL)
          exit_with_error("failed to compile module", error, NULL);

        printf("Creating callback...\\n");
        wasm_functype_t *hello_ty = wasm_functype_new_0_0();
        wasmtime_func_t hello;
        wasmtime_func_new(context, hello_ty, hello_callback, NULL, NULL, &hello);

        printf("Instantiating module...\\n");
        wasm_trap_t *trap = NULL;
        wasmtime_instance_t instance;
        wasmtime_extern_t import;
        import.kind = WASMTIME_EXTERN_FUNC;
        import.of.func = hello;
        error = wasmtime_instance_new(context, module, &import, 1, &instance, &trap);
        if (error != NULL || trap != NULL)
          exit_with_error("failed to instantiate", error, trap);

        printf("Extracting export...\\n");
        wasmtime_extern_t run;
        bool ok = wasmtime_instance_export_get(context, &instance, "run", 3, &run);
        assert(ok);
        assert(run.kind == WASMTIME_EXTERN_FUNC);

        printf("Calling export...\\n");
        error = wasmtime_func_call(context, &run.of.func, NULL, 0, NULL, 0, &trap);
        if (error != NULL || trap != NULL)
          exit_with_error("failed to call function", error, trap);

        printf("All finished!\\n");
        ret = 0;

        wasmtime_module_delete(module);
        wasmtime_store_delete(store);
        wasm_engine_delete(engine);
        return ret;
      }

      static void exit_with_error(const char *message, wasmtime_error_t *error, wasm_trap_t *trap) {
        fprintf(stderr, "error: %s\\n", message);
        wasm_byte_vec_t error_message;
        if (error != NULL) {
          wasmtime_error_message(error, &error_message);
          wasmtime_error_delete(error);
        } else {
          wasm_trap_message(trap, &error_message);
          wasm_trap_delete(trap);
        }
        fprintf(stderr, "%.*s\\n", (int) error_message.size, error_message.data);
        wasm_byte_vec_delete(&error_message);
        exit(1);
      }
    C

    system ENV.cc, "hello.c", "-I#{include}", "-L#{lib}", "-lwasmtime", "-o", "hello"
    expected = <<~EOS
      Initializing...
      Compiling module...
      Creating callback...
      Instantiating module...
      Extracting export...
      Calling export...
      Calling back...
      > Hello World!
      All finished!
    EOS
    assert_equal expected, shell_output("./hello")
  end
end
