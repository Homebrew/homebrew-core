class Wasmtime < Formula
  desc "Standalone JIT-style runtime for WebAssembly, using Cranelift"
  homepage "https://wasmtime.dev/"
  url "https://github.com/bytecodealliance/wasmtime.git",
      tag:      "v31.0.0",
      revision: "7a9be587f853ce4c4060fd4fcf9638d61907e6dd"
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
    sha256 cellar: :any,                 arm64_sequoia: "17eb5cc8369a253fe1faa761ba765ed4caa1a20cae6f0a2a8ed4636dd73cb8cd"
    sha256 cellar: :any,                 arm64_sonoma:  "d98caa573a57f6c076411df010773eff125b6a31d0ad35e592a47052b92e6653"
    sha256 cellar: :any,                 arm64_ventura: "84fc617bcd1ecd4a9cc9505a84bf1f4199af37b09f65040095914cc83d946189"
    sha256 cellar: :any,                 sonoma:        "08f6c2f41e42071fc3c5b7d77f257bd73f3d5080719f27ffbe078fc8e543136d"
    sha256 cellar: :any,                 ventura:       "dce889c6c19899318323fb856111c60143632f2b77dbdc4aab82ae862fb2cdc8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b6142943c4b72a11f1f6a17d2c2818840515dddb1061c7f414d89f561f6dd3f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "95b2fb7726a9d12e6e293cc7308ba14f5bc0c6402ea97063b223c011f240a53f"
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
