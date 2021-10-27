class Shfmt < Formula
  desc "Autoformat shell script source code"
  homepage "https://github.com/mvdan/sh"
  url "https://github.com/mvdan/sh/archive/v3.4.0.tar.gz"
  sha256 "0eb593457df63c5a98597f6235b1ff558fadd18aed54653604731906790a9c90"
  license "BSD-3-Clause"
  head "https://github.com/mvdan/sh.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "972fa05139ca8b1111455370a6e8be19a050067ebe9d176c1c05e3d1ee3d658c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "38f0107e79a8462e0813785ac59fad4cb6a27ad71f0e7c97d967b228a00604a9"
    sha256 cellar: :any_skip_relocation, monterey:       "8d2a8ce09acee0fb1e652db47f805fd06992490fb856d95c778911dd0d8ddc34"
    sha256 cellar: :any_skip_relocation, big_sur:        "8200fcf756b23f3e06fd07437b332d813280a3bb317e41a1d2b02e1f442a1966"
    sha256 cellar: :any_skip_relocation, catalina:       "73afc11e5d8f378dd818ebb0f7b16ffe1444742b06189a6ae344da867f3eec02"
    sha256 cellar: :any_skip_relocation, mojave:         "a5bd6ad427afcf75b6fe3aea673377d6664f295cc6c5b09bb49825fb1957df40"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "dd726795df67054c07fcd82ffaf8e543552b10e09d9af041c594e09dd3ad4dbf"
  end

  depends_on "go" => :build
  depends_on "scdoc" => :build

  def install
    ENV["CGO_ENABLED"] = "0"
    (buildpath/"src/mvdan.cc").mkpath
    ln_sf buildpath, buildpath/"src/mvdan.cc/sh"
    system "go", "build", "-a", "-tags", "production brew", "-ldflags",
                          "-w -s -extldflags '-static' -X main.version=#{version}",
                          "-o", "#{bin}/shfmt", "./cmd/shfmt"
    man1.mkpath
    system "scdoc < ./cmd/shfmt/shfmt.1.scd > #{man1}/shfmt.1"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/shfmt  --version")

    (testpath/"test").write "\t\techo foo"
    system "#{bin}/shfmt", testpath/"test"
  end
end
