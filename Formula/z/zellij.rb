class Zellij < Formula
  desc "Pluggable terminal workspace, with terminal multiplexer as the base feature"
  homepage "https://zellij.dev"
  url "https://github.com/zellij-org/zellij/archive/refs/tags/v0.45.0.tar.gz"
  sha256 "fba81ade9d3fd93869338553dce394a889e6f28e0e91f98896eb77533bab599b"
  license "MIT"
  head "https://github.com/zellij-org/zellij.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c0dbbee4a8b6a3a0053c618f88f1e3cd2718b4a280a6ee667d3de0ba0629af8d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9d3a08c3923a1f3d0e6930e71e27576a4a780761f4a26e1417ab19f2d74bac85"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "405a964bae49feb33ada4fbe769b4024f9524937de989a3ded29c5bf54ae152c"
    sha256 cellar: :any_skip_relocation, sonoma:        "07451e60c9eab8b8863783bdc2ec38fda930468c6a977e0bb49e488cff276f17"
    sha256 cellar: :any,                 arm64_linux:   "6ef48967ff26b374d46098a9638261d588b25cc5dac650513d775cb37448d564"
    sha256 cellar: :any,                 x86_64_linux:  "030ba2b2424b7330230af88be7490916f8d2534dae8b43f030ec6c2299139945"
  end

  depends_on "rust" => :build
  depends_on "openssl@3"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  service do
    run [opt_bin/"zellij", "web"]
    keep_alive true
    environment_variables PATH: std_service_path_env
    log_path var/"log/zellij.log"
    error_log_path var/"log/zellij.log"
  end

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = formula_opt_prefix("openssl@3")

    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"zellij", "setup", "--generate-completion")
  end

  test do
    assert_match("keybinds", shell_output("#{bin}/zellij setup --dump-config"))
    assert_match("zellij #{version}", shell_output("#{bin}/zellij --version"))
  end
end
