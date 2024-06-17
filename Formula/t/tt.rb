class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.3.1/tt-2.3.1-complete.tar.gz"
  sha256 "0e6a467cd8570b2719d7cf08fd707b3e6f2e473a9cb0d3f36b6322c392b4c86a"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cd51236bb96cc5ba374bbd9c4e5101c4d14eaf1a735902b62c1a0222169cc507"
    sha256 cellar: :any,                 arm64_ventura:  "b2763eef494545443c168393dd107b9d889c5b8c5f4bd5015c8aa2711236f030"
    sha256 cellar: :any,                 arm64_monterey: "51fe28c07519ea8945ecbf65f72f22664d4bf41e4658b781fa425edad63ad7e9"
    sha256                               sonoma:         "81e43e73407334fa0fb72e908907b7089f8d23ef1a500a332fd80d030ed0414a"
    sha256                               ventura:        "127aacef447bf723b4787ebeb9489466238ab8a2add38f0e843aac9c91755ca6"
    sha256                               monterey:       "cc2abf4c2a8cd85bddc35c05ee4c652884390002735237b5aaa031ff3c4b5ce2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d5ea0f0f05a0f66f77104747437db17e33bfcfc94c9e727acc17b3f953e858f0"
  end

  depends_on "go" => :build
  depends_on "mage" => :build
  depends_on "pkg-config" => :build
  depends_on "openssl@3"

  uses_from_macos "curl"
  uses_from_macos "unzip"
  uses_from_macos "zip"

  on_macos do
    depends_on "bash-completion"
  end

  def install
    ENV["TT_CLI_BUILD_SSL"] = "shared"
    system "mage", "build"
    bin.install "tt"
    (etc/"tarantool").install "package/tt.yaml.default" => "tt.yaml"

    generate_completions_from_executable(bin/"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
