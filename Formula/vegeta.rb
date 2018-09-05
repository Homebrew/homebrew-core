class Vegeta < Formula
  desc "HTTP load testing tool and library"
  homepage "https://github.com/tsenart/vegeta"
  url "https://github.com/tsenart/vegeta.git",
      :tag => "cli/v11.0.0",
      :revision => "6eef4b1ad4cb4a0318f031d517eeb232473d7955"

  bottle do
    cellar :any_skip_relocation
    sha256 "5a6c09a58457da6d6de746607edb4d763c23db3a862172583d8693ef597cd776" => :mojave
    sha256 "73d90510f49a30fcb6cd3740e57ed13f1f178b3881d574bb26c15b9caf980cdd" => :high_sierra
    sha256 "53eacf1e201b33df7fba7c6cd659b145e747ea1008a1f9e045aec79cf4ef3404" => :sierra
    sha256 "e28238ab34c4899bc646c8ab9c1ff1fb0976b379f527bf30ed3aa1fae2d54e00" => :el_capitan
  end

  depends_on "dep" => :build
  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/tsenart/vegeta").install buildpath.children
    ENV.prepend_create_path "PATH", buildpath/"bin"
    cd "src/github.com/tsenart/vegeta" do
      system "make", "vegeta"
      bin.install "vegeta"
      prefix.install_metafiles
    end
  end

  test do
    input = "GET https://google.com"
    output = pipe_output("#{bin}/vegeta attack -duration=1s -rate=1", input, 0)
    report = pipe_output("#{bin}/vegeta report", output, 0)
    assert_match /Success +\[ratio\] +100.00%/, report
  end
end
