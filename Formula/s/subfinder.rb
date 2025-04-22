class Subfinder < Formula
  desc "Subdomain discovery tool"
  homepage "https://github.com/projectdiscovery/subfinder"
  url "https://github.com/projectdiscovery/subfinder/archive/refs/tags/v2.7.0.tar.gz"
  sha256 "8f3d2867572e13917d8386f8d4fc88f80524c826facd91baed722b9bfd6026a5"
  license "MIT"
  head "https://github.com/projectdiscovery/subfinder.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4adfc7fb8727c0964d447ab7ca85ed3385488ccc76adbafb2e4e99b6211c17d8"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "cc596651cbc189ec7eb270ad445ec94ae38c927c59da39cfdcd73e42e5f34a7f"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "143a4e97e3ce97a7efb36d94c4c36f6f6b607e77f8bfe0dcb5d5899368570a32"
    sha256 cellar: :any_skip_relocation, sonoma:        "d3a2535455c881939dbf322d498c1659801ddbdcdb07a711aca31c1dd8448c6c"
    sha256 cellar: :any_skip_relocation, ventura:       "dcee2b1104d13bfbb0b15ac980be5cba562b083b1eda2805a5c4be5ae0d7504c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ce764710ffca361aeb41d47951d5dd9b6c59830535d1e1cd4451622d4a608dcd"
  end

  depends_on "go" => :build

  def install
    cd "v2" do
      system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/subfinder"
    end
  end

  test do
    assert_match "docs.brew.sh", shell_output("#{bin}/subfinder -d brew.sh")

    # upstream issue, https://github.com/projectdiscovery/subfinder/issues/1124
    if OS.mac?
      assert_path_exists testpath/"Library/Application Support/subfinder/config.yaml"
      assert_path_exists testpath/"Library/Application Support/subfinder/provider-config.yaml"
    else
      assert_path_exists testpath/".config/subfinder/config.yaml"
      assert_path_exists testpath/".config/subfinder/provider-config.yaml"
    end

    assert_match version.to_s, shell_output("#{bin}/subfinder -version 2>&1")
  end
end
