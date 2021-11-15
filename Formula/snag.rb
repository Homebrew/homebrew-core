class Snag < Formula
  desc "Automatic build tool for all your needs"
  homepage "https://github.com/Tonkpils/snag"
  url "https://github.com/Tonkpils/snag/archive/v1.2.0.tar.gz"
  sha256 "37bf661436edf4526adf5428ac5ff948871c613ff4f9b61fbbdfe1fb95f58b37"
  license "MIT"
  head "https://github.com/Tonkpils/snag.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1714f0e948566336c34fcf45dce8f7a5d76cfdcad20545af460dd271daf8bdde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "687d1c28e0f911d8343db56f993e4ab0088ec34e40b9a99c1139ec4f8db558c3"
    sha256 cellar: :any_skip_relocation, monterey:       "f3a6ed5e8543f7b4c6eda761a849680ffd869a6fe1d0b51eee3ecc6761d4fe9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b7076d11282b0ec9d25cf2f03e529dfc1d6d417dda5b80d44332a12767e68d1"
    sha256 cellar: :any_skip_relocation, catalina:       "008cc64d1a65693bf1773affb86ed185d5c91382f80f252877a5a6334986527a"
    sha256 cellar: :any_skip_relocation, mojave:         "3821de3f4b916afd116f9f55c549f1bdec7b2c448994e784baf23eef96d65520"
    sha256 cellar: :any_skip_relocation, high_sierra:    "ae031acea4e10639f15a1598bf99e45eb8bed08222e31db9e1152a4a1de0dc14"
    sha256 cellar: :any_skip_relocation, sierra:         "692ce892c40f38cb39e77b464efa531b27004a9bbaf0096fb5876b570086cf82"
    sha256 cellar: :any_skip_relocation, el_capitan:     "18a6d589a0b416ee502a8dacd6f919959d25cc08d9bbaad152fdade4c72634dc"
    sha256 cellar: :any_skip_relocation, yosemite:       "00edba081c3a56f6cda3a4fc5bb1125d8ce93a8239c3cae89346b1893df12025"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7096008e3aab8b00c45a600edab938bd16918a92543423662f3a6015e5a14edb"
  end

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/Tonkpils/").mkpath
    ln_s buildpath, buildpath/"src/github.com/Tonkpils/snag"

    system "go", "build", "-o", bin/"snag", "./src/github.com/Tonkpils/snag"
  end

  test do
    (testpath/".snag.yml").write <<~EOS
      build:
        - touch #{testpath}/snagged
      verbose: true
    EOS
    begin
      pid = fork do
        exec bin/"snag"
      end
      sleep 0.5
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
    assert_predicate testpath/"snagged", :exist?
  end
end
