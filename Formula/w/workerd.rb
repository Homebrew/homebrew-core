class Workerd < Formula
  desc "JavaScript and WebAssembly runtime for Cloudflare Workers"
  homepage "https://github.com/cloudflare/workerd"
  url "https://github.com/cloudflare/workerd/archive/refs/tags/v1.20261006.1.tar.gz"
  sha256 "5dc1faa5fc15f4489b8f3cabe58391b494a42b18c756b318c34ee0cc5b8b6b8a"
  license "Apache-2.0"
  head "https://github.com/cloudflare/workerd.git", branch: "main"

  depends_on "bazel" => :build
  depends_on "python@3.14" => :build
  depends_on "tcl-tk" => :build

  on_linux do
    depends_on "lld" => :build
    depends_on "llvm" => :build
  end

  # Bazel downloads build dependencies, and the test serves HTTP locally.
  allow_network_access! [:build, :test]

  def install
    # Use Homebrew's Bazel instead of the repository-pinned version.
    rm ".bazelversion"

    ENV.remove "PATH", Superenv.shims_path
    ENV.prepend_path "PATH", formula_opt_bin("llvm") if OS.linux?

    args = %W[
      --config=release
      --jobs=#{ENV.make_jobs}
      --repo_contents_cache=
      --action_env=PATH=#{ENV["PATH"]}
      --host_action_env=PATH=#{ENV["PATH"]}
    ]
    if OS.linux?
      args += %W[
        --linkopt=-L#{formula_opt_lib("llvm")}
        --host_linkopt=-L#{formula_opt_lib("llvm")}
        --host_linkopt=-Wl,-rpath,#{formula_opt_lib("llvm")}
      ]
    end
    # Avoid malformed Rust proc-macro libraries from debug stripping on macOS 27.
    args << "--@rules_rust//:extra_exec_rustc_flag=-Cstrip=none" if OS.mac?

    system "bazel", "--output_user_root=#{buildpath}/bazel-output", "build", *args,
                    "//src/workerd/server:workerd"
    bin.install "bazel-bin/src/workerd/server/workerd"
    (etc/"workerd").install "samples/helloworld/config.capnp", "samples/helloworld/worker.js"
  end

  service do
    run [opt_bin/"workerd", "serve", etc/"workerd/config.capnp"]
    keep_alive true
    working_dir etc/"workerd"
  end

  test do
    (testpath/"worker.js").write <<~JS
      export default {
        async fetch() {
          return new Response("Hello from workerd!");
        }
      };
    JS
    port = free_port
    (testpath/"config.capnp").write <<~CAPNP
      using Workerd = import "/workerd/workerd.capnp";
      const config :Workerd.Config = (
        services = [(name = "main", worker = (
          modules = [(name = "worker.js", esModule = embed "worker.js")],
          compatibilityDate = "2026-10-06",
        ))],
        sockets = [(name = "http", address = "127.0.0.1:#{port}", http = (), service = "main")],
      );
    CAPNP

    pid = spawn bin/"workerd", "serve", "config.capnp"
    begin
      assert_equal "Hello from workerd!", shell_output("curl --silent --retry 5 --retry-connrefused " \
                                                       "--retry-delay 1 http://127.0.0.1:#{port}")
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
