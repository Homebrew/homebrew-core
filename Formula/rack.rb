class Rack < Formula
  desc "CLI for Rackspace"
  homepage "https://github.com/rackspace/rack"
  url "https://github.com/rackspace/rack.git",
      tag:      "1.2",
      revision: "09c14b061f4a115c8f1ff07ae6be96d9b11e08df"
  license "Apache-2.0"
  head "https://github.com/rackspace/rack.git", branch: "master"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d81bffa7fcd9b0e5079359935e35b155a3e0a970b0526b50928c084522fcdc79"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3da24ffbc52e301b97902eee71ecddbbb16c6df508a9241a4a9ed2dc7eed0652"
    sha256 cellar: :any_skip_relocation, monterey:       "5f0280df3a5a8ea3e28533d43434ce2d97e0ba3ff35f74f1b3041008f594b820"
    sha256 cellar: :any_skip_relocation, big_sur:        "8f5f2eac4a06a9295875d213a31505f9b8e66e96b16814176582e3fd5a0a223e"
    sha256 cellar: :any_skip_relocation, catalina:       "8cf224e3f734308bef6c0ef3cd9aa3a63aa4fdedd9ee626e2ee91099affc83c2"
    sha256 cellar: :any_skip_relocation, mojave:         "a50004c910fc4cbb34404fabf20bfcab87dcf6d7ce510a96c72fecbdc8d458cc"
    sha256 cellar: :any_skip_relocation, high_sierra:    "5e33e2bc51e9cf346ed59eabbef5849a170619be2a7b034b19d71a1a25a72fcb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88a7a29b2c8fc2f04d5009bb498e2a424aaf2c246a55915c2f0d7b12f7accfec"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["TRAVIS_TAG"] = version
    ENV["GO111MODULE"] = "auto"

    rackpath = buildpath/"src/github.com/rackspace/rack"
    rackpath.install Dir["{*,.??*}"]

    cd rackpath do
      # This is a slightly grim hack to handle the weird logic around
      # deciding whether to add a = or not on the ldflags, as mandated
      # by Go 1.7+.
      # https://github.com/rackspace/rack/issues/446
      inreplace "script/build", "go1.5", Utils.safe_popen_read("go", "version")[/go1\.\d/]

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
