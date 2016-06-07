class Rack < Formula
  desc "CLI for Rackspace"
  homepage "https://github.com/rackspace/rack"
  url "https://github.com/rackspace/rack.git",
      :tag => "1.2",
      :revision => "09c14b061f4a115c8f1ff07ae6be96d9b11e08df"
  head "https://github.com/rackspace/rack.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "a0301d96ab10f35f417d51f22c85c5a2245848b42a75d5deb23c46b0b6f88dcc" => :el_capitan
    sha256 "74834b52803e42ec8b216b358d24e50a1ea80d01a7b826a54026038cfefbbb8f" => :yosemite
    sha256 "48ddc5dfd45f15ee9dd70a25719161296389cad484765ce0d99a94c43951e919" => :mavericks
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TRAVIS_TAG"] = version

    rackpath = buildpath/"src/github.com/rackspace/rack"
    rackpath.install Dir["{*,.??*}"]

    cd rackpath do
      ln_s "internal", "vendor"
      system "script/build", "rack"
      bin.install "rack"
    end
  end

  test do
    system "#{bin}/rack"
  end
end
