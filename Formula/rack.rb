class Rack < Formula
  desc "CLI for Rackspace"
  homepage "https://github.com/rackspace/rack"
  url "https://github.com/rackspace/rack.git",
      :tag => "1.2",
      :revision => "09c14b061f4a115c8f1ff07ae6be96d9b11e08df"
  head "https://github.com/rackspace/rack.git"

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "61fb0f5cb11684e5fd0723d823fce0948fcafa862e031c3253c4ff36bb8830d6" => :mojave
    sha256 "f5b447e509b01c080e73d8a275a60591e0a9b91d09d9aeff9aafe91b67538486" => :high_sierra
    sha256 "9e77b25dce5ebddece476a84fa04b32d3c904f4a825db343b128a8b3b4a4f4fd" => :sierra
    sha256 "7a17ae415465e10b0b5674218d5fb127c03782b5f49e741d8a84f94cde7c658a" => :el_capitan
    sha256 "d49a8f87439a1584e1662a570c7a40611d6cf13064e37f3a66cb7e1feaaa5719" => :yosemite
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TRAVIS_TAG"] = version

    rackpath = buildpath/"src/github.com/rackspace/rack"
    rackpath.install Dir["{*,.??*}"]

    cd rackpath do
      # This is a slightly grim hack to handle the weird logic around
      # deciding whether to add a = or not on the ldflags, as mandated
      # by Go 1.7+.
      # https://github.com/rackspace/rack/issues/446
      inreplace "script/build", "go1.5", Utils.popen_read("go version")[/go1\.\d/]

      ln_s "internal", "vendor"
      system "script/build", "rack"
      bin.install "rack"
      prefix.install_metafiles
    end
  end

  test do
    system "#{bin}/rack"
  end
end
