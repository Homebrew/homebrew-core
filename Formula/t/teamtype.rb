class Teamtype < Formula
  desc "Peer-to-peer, editor-agnostic collaborative editing of local text files"
  homepage "https://github.com/teamtype/teamtype"
  url "https://github.com/teamtype/teamtype/archive/refs/tags/v0.9.0.tar.gz"
  sha256 "eabc7a197a6d5f1a06855d168796f5db95e1d61cfe1cb9cb05ce6f4e3cec7cb9"
  license "AGPL-3.0-or-later"
  head "https://github.com/teamtype/teamtype.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "4167d805a9ca673742f74926d93fee28f70b38f369e70ce4c1bca73a4550485c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1f9e1566b9d76dc2e9fb6bb82c952fbb73bfff45128b20657023f74148741c27"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b10337c3b94b61247e909e7092bacc678ae59b2a3f57f10355b62015be54c510"
    sha256 cellar: :any_skip_relocation, sonoma:        "783ea10276bca6114f78ca1a0fae428dce806cca03d8d1bf54953878b996d43d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e2f429aafb4b93539d399194e25a098361019264535b20a3300c30d7271dbe7e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cbfbc77a57e1995bb4874da5f4976bfc4cd429e8ecd168e67c8c8872d746a7c9"
  end

  depends_on "rust" => :build

  uses_from_macos "zlib"

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
