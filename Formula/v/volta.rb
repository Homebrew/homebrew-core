class Volta < Formula
  desc "JavaScript toolchain manager for reproducible environments"
  homepage "https://volta.sh"
  url "https://github.com/volta-cli/volta/archive/refs/tags/v2.0.1.tar.gz"
  sha256 "4ccffc86b7841cb8bc9a55436529209dbbb9621992e43cbad48ccc7ffadba493"
  license "BSD-2-Clause"
  head "https://github.com/volta-cli/volta.git", branch: "main"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "c3f179ef8e08a6b9192a54f2c53104eb4e1633340b721cca0963b6b6428ba4f4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ccc458c5dce897081ef5647f3b7546b990156ff9d4ecf0e5e853ec3183ef6361"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "564451a02fe6a260d6b6c6931dbf5a254d492dbc4e56986b1ff017395f51bb06"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "048b23b6a53de02c00868b733a5ac804daaf25490072327314a8564fff745a81"
    sha256 cellar: :any_skip_relocation, sonoma:         "4bb7faa360726cf19a4b0a8ba4ce500a5050ea63ddd990b5cafaef3f1d215ed5"
    sha256 cellar: :any_skip_relocation, ventura:        "1a53b58df1edd4a2df65c0084e6736d16427ab786716972655ec0805391c3c5b"
    sha256 cellar: :any_skip_relocation, monterey:       "5920d42606af034e79d64e9fcbfc019921ffa16f246d2d1840bfc02a83bef95d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1e50806022ce887eb58b2880aff109e3a0f0a63827d9bf8ea3c543287500230b"
  end

  depends_on "rust" => :build

  uses_from_macos "bzip2"

  on_linux do
    depends_on "pkg-config" => :build
  end

  def install
    system "cargo", "install", *std_cargo_args
    generate_completions_from_executable(bin/"volta", "completions")

    bin.each_child do |f|
      basename = f.basename
      next if basename.to_s == "volta-shim"

      (libexec/"bin").install f
      (bin/basename).write_env_script libexec/"bin"/basename, VOLTA_INSTALL_DIR: opt_prefix/"bin"
    end
  end

  test do
    system bin/"volta", "install", "node@19.0.1"
    node = shell_output("#{bin}/volta which node").chomp
    assert_match "19.0.1", shell_output("#{node} --version")
    path = testpath/"test.js"
    path.write "console.log('hello');"
    output = shell_output("#{testpath}/.volta/bin/node #{path}").strip
    assert_equal "hello", output
  end
end
