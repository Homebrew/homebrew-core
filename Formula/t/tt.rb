class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.5.0/tt-2.5.0-complete.tar.gz"
  sha256 "aac32608eef800e2d1742e94dfb35fb3f06d40584d6387c03b79e20233db5512"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "f1925c0a9063dca3df87efc214c54e7dc31e606a9e1c8ff56d989218c16eb86f"
    sha256 cellar: :any,                 arm64_sonoma:  "c5fccaa916c393eea0be0a34855d8b4d88cc58c0940be1825dd985966129a7e7"
    sha256 cellar: :any,                 arm64_ventura: "dcf3624897c709765465595090f73cdc0c417fc84bac6b23862d06e5e57b6302"
    sha256                               sonoma:        "c8d79c86fab7edcbcc2dd9af18199f5be6950d885822b3940bacf02856b3d9d8"
    sha256                               ventura:       "5de457c2e4c7a081ca401f1a15a5c463743a8283a2b3bd4594ccef4c59165dee"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "47e61b3c3a437e5768af70a7b30a9520857502a04194b4a8cd38d2520c1727af"
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
