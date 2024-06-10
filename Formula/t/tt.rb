class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.3.0/tt-2.3.0-complete.tar.gz"
  sha256 "bd516b457cd0df19c4be9f905568219ca33d1955940c60c2a3e5b7e265ca29fd"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "af8011b3a83969def2584b4c4165e4cfc9168707c749647dcaf59ccf9f2d5c14"
    sha256 cellar: :any,                 arm64_ventura:  "09c817bd07127bc2b8871c4d796a9537f8a309b7fcc1e750e8eb9c37bc8716a1"
    sha256 cellar: :any,                 arm64_monterey: "8ef9b3a2b29be4dca04529c38bcf67d372d68d73f9f8381495ff73cd7e3ecbb3"
    sha256                               sonoma:         "76517ec6d4fa4c969eaab4f6fb3f94f626340fd8a509197a2ec8a50e2bbc3c73"
    sha256                               ventura:        "1c42fd9c550427ddeec7d3805fbc4a2edae44ef4efa4e73d052ea42fb8e02c78"
    sha256                               monterey:       "144b8e0785a6c9d1a849ba7bb793a1dc2a9baf1f10ed2567e5be8a3c8ea8e64b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cbe4c6baa41f9b2951cc159b891ed3de0522bd602897a5125b6eae0f4d125fce"
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
