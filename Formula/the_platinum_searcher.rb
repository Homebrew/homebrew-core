class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v2.2.0.tar.gz"
  sha256 "3d5412208644b13723b2b7ca4af0870d25c654e3a76feee846164c51b88240b0"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "b2e99bee242a5b9a1667a321de1e777eb83a8023b034ebe0da3fc0953a193f26" => :mojave
    sha256 "5b85047b2b893e8ec45e3f68b37c09cfb80ceb0a7c2b9c70937f2f2ca1f6f0bc" => :high_sierra
    sha256 "1e952c6a666f180343cfdc1afa859f702638276e597d4292520fa6cf91ac82b8" => :sierra
    sha256 "3439437518655cdd74c95eda5a161c01d5fe80604ef9c3e8936449a96ba3dcc1" => :el_capitan
  end

  depends_on "go" => :build
  depends_on "godep" => :build

  def install
    ENV["GOPATH"] = buildpath
    dir = buildpath/"src/github.com/monochromegane/the_platinum_searcher"
    dir.install buildpath.children
    cd dir do
      system "godep", "restore"
      system "go", "build", "-o", bin/"pt", ".../cmd/pt"
      prefix.install_metafiles
    end
  end

  test do
    path = testpath/"hello_world.txt"
    path.write "Hello World!"

    lines = `#{bin}/pt 'Hello World!' #{path}`.strip.split(":")
    assert_equal "Hello World!", lines[2]
  end
end
