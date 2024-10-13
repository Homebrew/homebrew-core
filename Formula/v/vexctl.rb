class Vexctl < Formula
  desc "Tool to create, transform and attest VEX metadata"
  homepage "https://openssf.org/projects/openvex/"
  url "https://github.com/openvex/vexctl/archive/refs/tags/v0.3.0.tar.gz"
  sha256 "5a5904448ef1bf11bd8a165d737acc88afd9799618f6583c15cee5d99dd58e17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e6ce7e26fa5819ccf87de00241fb22fb9b2105740a57f345aeca492fc28902a8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e6ce7e26fa5819ccf87de00241fb22fb9b2105740a57f345aeca492fc28902a8"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e6ce7e26fa5819ccf87de00241fb22fb9b2105740a57f345aeca492fc28902a8"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6ce7e26fa5819ccf87de00241fb22fb9b2105740a57f345aeca492fc28902a8"
    sha256 cellar: :any_skip_relocation, sonoma:         "971ef9d2c5783f76a24fdaf9bea3f5c454970011ad67659511114214d22dbcbb"
    sha256 cellar: :any_skip_relocation, ventura:        "afb6ea108d1e5d64272191ab280440f78687501a76efedeb6be4053c50777a8d"
    sha256 cellar: :any_skip_relocation, monterey:       "40ee1b591faecd403a883927fe9ac5cac51f51981b5ccc3a43944f881a30300b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f2f1a9cf436e83b91094189a1659f91be736bf3857a9aa1bfa7b214aad63deb"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match "Valid Statuses:\n\tnot_affected\n\taffected\n\tfixed\n\tunder_investigation\n",
    shell_output("#{bin}/vexctl list status")
  end
end
