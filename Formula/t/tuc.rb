class Tuc < Formula
  desc "Text manipulation and cutting tool"
  homepage "https://github.com/riquito/tuc"
  url "https://github.com/riquito/tuc/archive/refs/tags/v1.3.0.tar.gz"
  sha256 "81dc5f4a0355ecdf9515c88c34c365d20f339d316df7dbe72667cd2b18445c61"
  license "GPL-3.0-or-later"
  head "https://github.com/riquito/tuc.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "d8368bcbeb63d6af7ba8c279723ccbbdf3779ade8f14a1dc7cac1db98b61d1bd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6423b86779b7adb9dbd51a0614bba4367c827aa90802ba4b6f9b64422b10110b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "5cecfa65eff149ea2095592f5ec310182b5801a62f4e2e09ce233838716e8674"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "82286170a0face60057a9bfcf202542473ac1f698915aa5390a15591e2e0452b"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a308ef5da38037c8a7e77db5000aa2ef5fb52fe974e49f5f44522b199c939c0"
    sha256 cellar: :any_skip_relocation, ventura:       "464244aec270c457d24ce5059ddd6e105b19071c63032705e2cf21b6dd32e715"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "de55cc6dc3472e93627ec3c691410cccc25ee560c1bf027cf39fac5ef88002a1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b6e58bc262cc056acb46774e08cd64f6eb7dc33d952ce4d8ade6ef3a29d5fda9"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--features", "regex", *std_cargo_args
  end

  test do
    output = pipe_output("#{bin}/tuc -e '[, ]+' -f 1,3", "a,b, c")
    assert_equal "ac\n", output
  end
end
