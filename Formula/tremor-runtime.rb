class TremorRuntime < Formula
  desc "Early-stage event processing system for unstructured data"
  homepage "https://www.tremor.rs/"
  url "https://github.com/tremor-rs/tremor-runtime/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "91cbe0ca5c4adda14b8456652dfaa148df9878e09dd65ac6988bb781e3df52af"
  license "Apache-2.0"
  head "https://github.com/tremor-rs/tremor-runtime.git", branch: "main"

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
    depends_on "gcc"
    depends_on "llvm"
    depends_on "openssl@1.1"
  end

  # gcc9+ required for c++20
  fails_with gcc: "5"
  fails_with gcc: "6"
  fails_with gcc: "7"
  fails_with gcc: "8"

  def install
    inreplace ".cargo/config", "+avx,+avx2,", ""

    system "cargo", "install", *std_cargo_args(path: "tremor-cli")

    (bash_completion/"tremor").write Utils.safe_popen_read("#{bin}/tremor", "completions", "bash")
    (zsh_completion/"_tremor").write Utils.safe_popen_read("#{bin}/tremor", "completions", "zsh")
    (fish_completion/"tremor.fish").write Utils.safe_popen_read("#{bin}/tremor", "completions", "fish")

    # main binary
    bin.install "target/release/tremor"

    # stdlib
    (lib/"tremor-script").install (buildpath/"tremor-script/lib").children

    # sample config for service
    (etc/"tremor").install "docker/config/docker.troy" => "main.troy"

    # wrapper
    (bin/"tremor-wrapper").write_env_script (bin/"tremor"), TREMOR_PATH: "#{lib}/tremor-script"
  end

  # demo service
  service do
    run [opt_bin/"tremor-wrapper", "run", etc/"tremor/main.troy"]
    keep_alive true
    working_dir HOMEBREW_PREFIX
    log_path var/"log/tremor.log"
    error_log_path var/"log/tremor_error.log"
  end

  test do
    assert_match "tremor #{version}\n", shell_output("#{bin}/tremor --version")

    (testpath/"test.troy").write <<~EOS
      define flow test
      flow
          use tremor::connectors;

          define pipeline capitalize
          into
              out, err, exit
          pipeline
              use std::string;
              use std::time::nanos;
              select string::uppercase(event) from in into out;
              select {"exit": 0, "delay": nanos::from_seconds(1) } from in into exit;
          end;

          define connector file_in from file
              with codec="string", config={"path": "#{testpath}/in.txt", "mode": "read"}
          end;
          define connector file_out from file
              with codec="string", config={"path": "#{testpath}/out.txt", "mode": "truncate"}
          end;

          create pipeline capitalize from capitalize;
          create connector input from file_in;
          create connector output from file_out;
          create connector exit from connectors::exit;

          connect /connector/input to /pipeline/capitalize;
          connect /pipeline/capitalize to /connector/output;
          connect /pipeline/capitalize/exit to /connector/exit;
      end;

      deploy flow test;
    EOS

    (testpath/"in.txt").write("hello")

    system bin/"tremor-wrapper", "run", testpath/"test.troy"

    assert_match(/^HELLO/, (testpath/"out.txt").readlines.first)
  end
end
