class Snag < Formula
  desc "Automatic build tool for all your needs"
  homepage "https://github.com/Tonkpils/snag"
  url "https://github.com/Tonkpils/snag/archive/refs/tags/v1.2.0.tar.gz"
  sha256 "37bf661436edf4526adf5428ac5ff948871c613ff4f9b61fbbdfe1fb95f58b37"
  license "MIT"
  head "https://github.com/Tonkpils/snag.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "d78b5afc3692d32a42500fff33a42c68783140d27318051052fc0bba9cf8bd15"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e3047af31785c147bfb9cf1fb8d3621de36339c95e49393f0fed5c0d60b933c5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fa9946a8925f1aa3881c48e93893a412938c9681f0bd2427a4d652e366c0aedc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1714f0e948566336c34fcf45dce8f7a5d76cfdcad20545af460dd271daf8bdde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "687d1c28e0f911d8343db56f993e4ab0088ec34e40b9a99c1139ec4f8db558c3"
    sha256 cellar: :any_skip_relocation, sonoma:         "c06aa3205e4da50e8123ef2926b08de62ffa8129e8dfe3c39cae4d7acc5ccfb4"
    sha256 cellar: :any_skip_relocation, ventura:        "e9512e6adfaa81d36ec98c2b95e2cd5dcd2bc9bda8fa441fb9c37f01d565106d"
    sha256 cellar: :any_skip_relocation, monterey:       "f3a6ed5e8543f7b4c6eda761a849680ffd869a6fe1d0b51eee3ecc6761d4fe9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "5b7076d11282b0ec9d25cf2f03e529dfc1d6d417dda5b80d44332a12767e68d1"
    sha256 cellar: :any_skip_relocation, catalina:       "008cc64d1a65693bf1773affb86ed185d5c91382f80f252877a5a6334986527a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7096008e3aab8b00c45a600edab938bd16918a92543423662f3a6015e5a14edb"
  end

  # https://github.com/Tonkpils/snag/issues/66
  deprecate! date: "2024-02-24", because: :unmaintained
  disable! date: "2025-02-24", because: :unmaintained

  depends_on "go" => :build

  def install
    ENV["GOPATH"] = buildpath
    ENV["GO111MODULE"] = "auto"

    (buildpath/"src/github.com/Tonkpils/").mkpath
    ln_s buildpath, buildpath/"src/github.com/Tonkpils/snag"

    system "go", "build", "-o", bin/"snag", "./src/github.com/Tonkpils/snag"
  end

  test do
    (testpath/".snag.yml").write <<~YAML
      build:
        - touch #{testpath}/snagged
      verbose: true
    YAML
    begin
      pid = fork do
        exec bin/"snag"
      end
      sleep 0.5
    ensure
      Process.kill "TERM", pid
      Process.wait pid
    end
    assert_path_exists testpath/"snagged"
  end
end
