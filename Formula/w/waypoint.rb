class Waypoint < Formula
  desc "Tool to build, deploy, and release any application on any platform"
  homepage "https://www.waypointproject.io/"
  # NOTE: Do not bump to v0.12.0+ as license changed to BUSL-1.1
  # https://github.com/hashicorp/waypoint/pull/4878
  # https://github.com/hashicorp/waypoint/pull/4888
  url "https://github.com/hashicorp/waypoint/archive/v0.11.4.tar.gz"
  sha256 "e2526a621880fdc92c285250242532d2e9c5053fd53d2df9ad4ca7efa6b951a3"
  license "MPL-2.0"
  head "https://github.com/hashicorp/waypoint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "5cb2babffdd9b657b72c097f1806e99654797855aa12c0f3d51fd3f4fb318064"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a4367345e7868f66e6a09973b4f4b6ca3ac6a677eb206aeb5ad2b110aee837fa"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d55315b0a0f124132b146eb42ad222556c60e97c26b28975f1ac500fab5b2b53"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5ef5a5a7a1960ddcadbd0be2493bd49e22be1d36c65a54e1f9adf32397a98bb"
    sha256 cellar: :any_skip_relocation, sonoma:         "dfe641ec0be4e75d03d07b7e7c193b5e188e9ef61b83f379e9b351a095605b90"
    sha256 cellar: :any_skip_relocation, ventura:        "8d2da5fd33fa22a0293659aa8cf8c000acd2d0d48a8a7fe386e670f12e6e0b2b"
    sha256 cellar: :any_skip_relocation, monterey:       "b3ef9113241c9a4e247f7d92148737d391a1edc41a51428247846b02cb9d82db"
    sha256 cellar: :any_skip_relocation, big_sur:        "cd00a901000ca5d1b12439624fb77e37c69dd7d58316c937a2317162d8a4c24f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e2386f08d39846c93368dd3e3352ec6391d2215231280a746bf605261c9df2d5"
  end

  # https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
  deprecate! date: "2023-09-27", because: "will change its license to BUSL on the next release"

  depends_on "go" => :build
  depends_on "go-bindata" => :build

  def install
    system "make", "bin"
    bin.install "waypoint"
  end

  def caveats
    <<~EOS
      We will not accept any new Waypoint releases in homebrew/core (with the BUSL license).
      The next release will change to a non-open-source license:
      https://www.hashicorp.com/blog/hashicorp-adopts-business-source-license
      See our documentation for acceptable licences:
        https://docs.brew.sh/License-Guidelines
    EOS
  end

  test do
    output = shell_output("#{bin}/waypoint context list")
    assert_match "No contexts. Create one with `waypoint context create`.", output

    assert_match "! failed to create client: no server connection configuration found",
      shell_output("#{bin}/waypoint server bootstrap 2>&1", 1)

    assert_match version.to_s, shell_output("#{bin}/waypoint version")
  end
end
