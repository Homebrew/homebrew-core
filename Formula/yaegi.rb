class Yaegi < Formula
  desc "Yet another elegant Go interpreter"
  homepage "https://github.com/traefik/yaegi"
  url "https://github.com/traefik/yaegi/archive/v0.13.0.tar.gz"
  sha256 "73af6b8c765bf05abd6e9c209772db686b881a1c6d534542cd35de80743a1b34"
  license "Apache-2.0"
  head "https://github.com/traefik/yaegi.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6560eeba9ee315eb07008d150c48e260bf96f057300fe2dcc2ee8dbb58eb47c3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "413085effa5fa0efda92687820eb0703ef27a3c1b6b40d81b77d05b2ee0b3451"
    sha256 cellar: :any_skip_relocation, monterey:       "7418a92931fca81b88f4a3bb6d6a8b1909ab5688897056bfcdf4b013e9549625"
    sha256 cellar: :any_skip_relocation, big_sur:        "4a6e476e1d87a1a64dece9da7e33756de7d6c65451cac86959f1850627c5098b"
    sha256 cellar: :any_skip_relocation, catalina:       "621005a5bffb9e5e3e0b148e319c90011c0049aab4c854441a90b1426682b3c8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4239e0113c9520d6a1a972cb3201cfa3a863728b62c4b025319fe555be18171"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-X=main.version=#{version}"), "./cmd/yaegi"
  end

  test do
    assert_match "4", pipe_output("#{bin}/yaegi", "println(3 + 1)", 0)
  end
end
