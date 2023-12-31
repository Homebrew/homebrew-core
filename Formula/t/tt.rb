class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.1.0/tt-2.1.0-complete.tar.gz"
  sha256 "ede0cdcb19cd17b1094530b4b6d639aa2898621ec470fc15e7eb771c7547f5b2"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "af38470566d13f9c480809fa3a4d30be290e11326ecfeebf77df1e31d9bbfa79"
    sha256 cellar: :any,                 arm64_ventura:  "52c866b6c1764cd5d39655ca62704ce2e55a951159830f9d193976c96bc9d751"
    sha256 cellar: :any,                 arm64_monterey: "46e4e57ad43deac9b2539386cde94e249d18f0d4f83b1a68b27889a3cdd5cf71"
    sha256                               sonoma:         "5f887f3ab2e80ab1a41e163a875fa04e2dbf327b2ac505e9e62f63b2fdb518ee"
    sha256                               ventura:        "0378bcf994de806589bf05598e410b08121759aacdb8ac8ea73b39d87ae73f2d"
    sha256                               monterey:       "fd9eadd141199f13ca15e7b6a0e893755e9fd12f154faaf84391928ee35e68c5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd87b2b2c2f735ed631740ef5c4b06dff22591e7d469ee764d00c957b202a5e2"
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
    (etc/"tarantool").install "tt.yaml.default" => "tt.yaml"
    generate_completions_from_executable(bin/"tt", "completion", shells: [:bash, :zsh])
  end

  test do
    system bin/"tt", "init"
    system bin/"tt", "create", "cartridge", "--name", "cartridge_app", "-f", "--non-interactive", "-d", testpath
    assert_path_exists testpath/"cartridge_app/init.lua"
  end
end
