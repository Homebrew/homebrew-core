class Tt < Formula
  desc "Command-line utility to manage Tarantool applications"
  homepage "https://github.com/tarantool/tt"
  url "https://github.com/tarantool/tt/releases/download/v2.5.2/tt-2.5.2-complete.tar.gz"
  sha256 "c3312a6965f1cb51f76a828733aa84e7807d0018271456a0d70e42962b51b4c8"
  license "BSD-2-Clause"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "9ea709520820dabe222c65fd5be978f5973e3e09db5f30a62bb916c0ebb6b91d"
    sha256 cellar: :any,                 arm64_sonoma:  "3fe472511a8766e5c75d3d936b6e9fc1c243218121a3a3faab5b10744c724ee9"
    sha256 cellar: :any,                 arm64_ventura: "f6a4feee47e8dbaa01b4222bb56f4e92cf8a3e15ddefe33dfd41bbe8b1da76e2"
    sha256                               sonoma:        "0a99c40640581b47f329a25eb36163a9f3de15397793fb2b49690dfbef8e3abc"
    sha256                               ventura:       "de982ed920e80e98b33a86b0556f82db2cca09ca8ad18d7be75fd95b9ef3269b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "2f7d31095f5423bed8b6f2108985a85a2387017382b32317f289ea4c3933c1d5"
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
