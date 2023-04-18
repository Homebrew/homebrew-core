class TremorRuntime < Formula
  desc "Early-stage event processing system for unstructured data"
  homepage "https://www.tremor.rs/"
  url "https://github.com/tremor-rs/tremor-runtime/archive/refs/tags/v0.12.4.tar.gz"
  sha256 "91cbe0ca5c4adda14b8456652dfaa148df9878e09dd65ac6988bb781e3df52af"
  license "Apache-2.0"
  head "https://github.com/tremor-rs/tremor-runtime.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "96864c51d8cade85a5f41fa383e58b2536291ccd548e30f429dd331744c8c6b1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0d58f90918cf00d4adca64e53935ba29e5c0fb0ff08d6f2a6ce8ebc8bc6df12"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f8c977361698fecc8d63b749f54ebdd482c82af98ca72b3678e365e74c5a54a"
    sha256 cellar: :any_skip_relocation, ventura:        "56253e033b958ad4d7d0e8e3ae4f38e02379c4e8c073ce83700a282b9c6d504e"
    sha256 cellar: :any_skip_relocation, monterey:       "53fdb05b8cd063bc63223cde126aa0ec5452c69fcd7b94ccd1afac215912e396"
    sha256 cellar: :any_skip_relocation, big_sur:        "7383fe3a97615a0723f4726f66c3d399ee62dbd5d48e63fe49fa4a8a3734a344"
    sha256 cellar: :any_skip_relocation, catalina:       "049f89157dadffbe38688c1b60a422f1befccd6ab1625cc7bb5a9a9345ed330c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "12c9d851db248e68c21e1a0f016d1c18ce965d39be48a17bf3420ffe860c4977"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "pkg-config" => :build
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

    generate_completions_from_executable(bin/"tremor", "completions", base_name: "tremor")

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
