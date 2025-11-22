class TfstateLookup < Formula
  desc "Lookup resource attributes in tfstate"
  homepage "https://github.com/fujiwara/tfstate-lookup"
  url "https://github.com/fujiwara/tfstate-lookup/archive/refs/tags/v1.8.0.tar.gz"
  sha256 "826e3b3a8a382458aec4af36590e3f4d29d9b800906c69947d84f9320d5b2bfd"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "05ba6008cac5aa9d0abe9d76010b2734e91900ba7668d9d084d6c96d9845de23"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "05ba6008cac5aa9d0abe9d76010b2734e91900ba7668d9d084d6c96d9845de23"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "05ba6008cac5aa9d0abe9d76010b2734e91900ba7668d9d084d6c96d9845de23"
    sha256 cellar: :any_skip_relocation, sonoma:        "8fd0fe654d497165ae36ffcf750f3f34506ff2137d863f1da7394b6bbab1f620"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a84425fca42cba088f3f5b3c84e199c3f757c9f9ad1de20f8468d5d3617bbb0d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ca7906718379463fdae7435df1cf0565c16807dd98e495f57c51d74e5ea8c7d0"
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
