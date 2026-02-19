class Wapm < Formula
  desc "WebAssembly Package Manager (CLI)"
  homepage "https://wapm.io/"
  url "https://github.com/wasmerio/wapm-cli/archive/refs/tags/v0.5.9.tar.gz"
  sha256 "67f98e7e584ee05b53a70e19624ca73538aef28f46e1bb31c49262ba0e00a2ec"
  license "MIT"
  head "https://github.com/wasmerio/wapm-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "34251ab13608ada57daca8bb40d97979ec895c7a1e9ba1c9f6ccd2e5e0307068"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "64bcf4597cca94cacbe81f5171e942822148f75e4a5a6996c4a03755f853695d"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8b08738bc1b9beda9d2a865bff6cafe3fa4216bf96c9252c35646718f5f1607d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff4e64b42f0dc537ce9ff5dfc463af0adda2fe75526eee5d42da45484747646c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "572c1d1a4ad8b4a56affef4ef40085b875f9f655f439fecd249f620b1b632caf"
    sha256 cellar: :any_skip_relocation, sonoma:         "2d9990dc2cac2d3b46b6bdbe1443de739d774d37ed64172b34e025d95883d930"
    sha256 cellar: :any_skip_relocation, ventura:        "5478c5f66e9b93bc517fbd617131457369af4db06a3adacd5154fe1f4866c07f"
    sha256 cellar: :any_skip_relocation, monterey:       "d8ac65e18e12300294d391210f8944fdf3a21a2580c1e633f4399085f6c98780"
    sha256 cellar: :any_skip_relocation, big_sur:        "429a76f2db523702a2c6ce40c0f0e4562f0756e22882680b2e7e6e94e2f2a675"
    sha256 cellar: :any_skip_relocation, catalina:       "d164b8af6b8a005697c6795e9c53df98200fb1b6cdc103ecce68dd69b135525c"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "71ed13219631ca8b4893c6788aadc5d1aa133e1ddd9a3da1daf0555e6a36f93b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f7ee08cb75bf71add9b45bd1df5b65b605ac8d667349e745948cc8dcb089721e"
  end

  deprecate! date: "2024-04-05", because: :repo_archived
  disable! date: "2025-04-08", because: :repo_archived

  depends_on "rust" => :build
  depends_on "wasmer" => :test

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    ENV["WASMER_DIR"] = ".wasmer"
    ENV["WASMER_CACHE_DIR"] = "#{ENV["WASMER_DIR"]}/cache"
    Dir.mkdir ENV["WASMER_DIR"]
    Dir.mkdir ENV["WASMER_CACHE_DIR"]

    system bin/"wapm", "install", "cowsay"

    expected_output = <<~'EOF'
       _____________
      < hello wapm! >
       -------------
              \   ^__^
               \  (oo)\_______
                  (__)\       )\/\
                     ||----w |
                      ||     ||
    EOF
    assert_equal expected_output, shell_output("#{bin}/wapm run cowsay hello wapm!")

    system bin/"wapm", "uninstall", "cowsay"
  end
end
