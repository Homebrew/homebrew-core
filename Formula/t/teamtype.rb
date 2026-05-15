class Teamtype < Formula
  desc "Peer-to-peer, editor-agnostic collaborative editing of local text files"
  homepage "https://github.com/teamtype/teamtype"
  url "https://github.com/teamtype/teamtype/archive/refs/tags/v0.9.1.tar.gz"
  sha256 "8503411b340f00456ac6c1d586637de35a35886b7addbf2cec06816e05bc9873"
  license "AGPL-3.0-or-later"
  head "https://github.com/teamtype/teamtype.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "f305fb49649d180299c2cd52a2e24c92088389058c9069cd07e272d237656019"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f3d701160add6b5f51cbd6b8dd79cee38b26ae3bd1dfeba6dd6d5f526e9d309e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b1caebb81e31e88e9d3de8fd439293bf5078c903b021cb79d35806eb87662575"
    sha256 cellar: :any_skip_relocation, sonoma:        "894b2d5c75a01fce4f124476df1cc0438b160a12688749bb355148162c4e20ad"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "48431d07b888a42dcac294713e26a88f72e68dc1427f9795db5ae31c9728d348"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f13a452a13a112335fece8cb2a97e23414c7164ae7d22eec8a180525ec4553b7"
  end

  depends_on "rust" => :build

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    cd "daemon" do
      system "cargo", "install", *std_cargo_args
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/teamtype --version")

    (testpath/".teamtype").mkpath
    expected = "For security reasons, the parent directory of the socket must only be accessible by the current user"
    assert_match expected, pipe_output("#{bin}/teamtype share 2>&1", "y", 1)
  end
end
