class Td < Formula
  desc "Your todo list in your terminal"
  homepage "https://github.com/Swatto/td"
  url "https://github.com/Swatto/td/archive/refs/tags/1.4.2.tar.gz"
  sha256 "e85468dad3bf78c3fc32fc2ab53ef2d6bc28c3f9297410917af382a6d795574b"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "ed379b6dd0971f68d160943435d87d150b664e0b4e9037654dfe50dc85e4014c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "386a1ba61c06bcdafaa9afedf609caa8eba893e2dbe50326122e03495ad9eff1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cea6b716c9daded4db7c3f1da8515348cd5ab876eefc9c8e1e28e3a3833379ef"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4726f25e4fea482ddc0341f590311e2098e4e5a3b12f569376d85e1c5570d09"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "183862b016182f09f43d0c3092fdcb50894ca9f5814b83af816f1d4329368eab"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c78967ab33419211ed531310b5d40da8b7cfdb4573099d8e1b38b940c75d7a24"
    sha256 cellar: :any_skip_relocation, sonoma:         "eb030b14d31d5c32a5627be4c8bfb0a049416894c4f0e44204029f43cd65395a"
    sha256 cellar: :any_skip_relocation, ventura:        "ae0fe556264d24e6e18f4ecfbea037d1888269412dfab6a2e4c655b793985329"
    sha256 cellar: :any_skip_relocation, monterey:       "4de1e88f3b9f6477a154a6f5e946a7411a5a30a4e054d3fac9ad9b62d5964b4c"
    sha256 cellar: :any_skip_relocation, big_sur:        "665d2709804555227ee9fdffdf918574902345547bec837c53cd06fff04212c9"
    sha256 cellar: :any_skip_relocation, catalina:       "b3fb2df4df96602895a40900d682fa42ca9bbbc814463eeccd50ddc2cae8f485"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "a5463d1085c518796a801c19c708a6a1e68da5769b4209c83de7437a361b1e4c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "32afc5a28386f21e96fad99d94094b1011519e21bcbfd7ee14e6cef892f36e68"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    (testpath/".todos").write "[]\n"
    system bin/"td", "a", "todo of test"
    todos = (testpath/".todos").read
    assert_match "todo of test", todos
    assert_match "pending", todos
  end
end
