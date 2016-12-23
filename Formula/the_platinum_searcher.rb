class ThePlatinumSearcher < Formula
  desc "Multi-platform code-search similar to ack and ag"
  homepage "https://github.com/monochromegane/the_platinum_searcher"
  url "https://github.com/monochromegane/the_platinum_searcher/archive/v2.1.5.tar.gz"
  sha256 "dfed3b92f35501d063a2c646d5dfd51f2ee12cee53dd9e1d04a6c7710b71050f"
  head "https://github.com/monochromegane/the_platinum_searcher.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "90de0e8a5dd79f0aee57195bc67e38bf31d463503b0998da7f3ffefc033d14a6" => :sierra
    sha256 "f6664670adb1962b1d98c36362c51aceff066681197cfcf13f40a7c120b4e43b" => :el_capitan
    sha256 "f4523e3861799fcb8ceb43db725e33c8b86f8dc93bd3cdac9573c2b624b3d1a9" => :yosemite
    sha256 "cac0c68ab54c5869bffe00217443afd02e10ac95b1cf0c5a9a03f83cd961e8c1" => :mavericks
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
