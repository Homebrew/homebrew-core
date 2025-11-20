class TfstateLookup < Formula
  desc "Lookup resource attributes in tfstate"
  homepage "https://github.com/fujiwara/tfstate-lookup"
  url "https://github.com/fujiwara/tfstate-lookup/archive/refs/tags/v1.7.1.tar.gz"
  sha256 "25cdce913064998704a8b5d26ff01a572564531999211e6c05b382f20df03f7e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ec6c860f2042486eda3902de89f8927e5d9399a052b38b0fea5b553c3ac527d7"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ec6c860f2042486eda3902de89f8927e5d9399a052b38b0fea5b553c3ac527d7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ec6c860f2042486eda3902de89f8927e5d9399a052b38b0fea5b553c3ac527d7"
    sha256 cellar: :any_skip_relocation, sonoma:        "dcdd6c4010e472341aac6bbf7daed018e323d90de529723c067b5dba7fbd473a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "daa9fe3570937c49eb9a1d52155f063a4885cfddd78c72242212b8c396524d05"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7ffa1abd666e9b02d9fa1654b29bfe6462720139e85efa8140b580aab8398b1"
  end

  depends_on "go" => :build

  def install
    system "go", "build", *std_go_args(ldflags: "-s -w"), "./cmd/tfstate-lookup"
  end

  test do
    (testpath/"terraform.tfstate").write <<~EOS
      {
        "version": 4,
        "terraform_version": "1.7.2",
        "resources": []
      }
    EOS

    output = shell_output("#{bin}/tfstate-lookup -dump")
    assert_match "{}", output
  end
end
