class Termsvg < Formula
  desc "Record, share and export your terminal as a animated SVG image"
  homepage "https://github.com/MrMarble/termsvg"
  url "https://github.com/MrMarble/termsvg/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "7b9c7aae3f58c9dce7930fe2868e39d59817e143d13e5771c268f9c7f0cbdf31"
  license "GPL-3.0-only"
  head "https://github.com/MrMarble/termsvg.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "363363e29f811eb53cd39e456c15c7c6ccef0f00f84bb0edd67b22151265c42e"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "363363e29f811eb53cd39e456c15c7c6ccef0f00f84bb0edd67b22151265c42e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "363363e29f811eb53cd39e456c15c7c6ccef0f00f84bb0edd67b22151265c42e"
    sha256 cellar: :any_skip_relocation, sonoma:        "6b803686c893179cef6188beb67d6e7c1eb9af8dbea5a0dfc3a3a8931ca16e5e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "bbcb76116d128262297b857a7d6858b717ba81ff742e224d4e5bd7943433d93d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0ea62b9ca79d8a7fd00715bae7f7a76d072a303cc2b6e60aca1dc474773f2d69"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user} -X main.date=#{time.iso8601}"
    system "go", "build", *std_go_args(ldflags:), "./cmd/termsvg"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/termsvg --version")

    output = shell_output("#{bin}/termsvg play nonexist 2>&1", 80)
    assert_match "no such file or directory", output
  end
end
