class Vet < Formula
  desc "Policy driven vetting of open source dependencies"
  homepage "https://github.com/safedep/vet"
  url "https://github.com/safedep/vet/archive/refs/tags/v1.10.2.tar.gz"
  sha256 "4a9bfcede2946f9ee7d2c48584b1cf938078629196d6928989acae0601ba6f20"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "5a523a3cf2cb8fd42e439e86303153e81030ad776c1e71ef55cf783a102bd601"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "d228fad548fd7a66b376c7e0f54a60b0bf9b4cd96157987176c594c451e4f094"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "105a08ea662547ef4272e40918871669e5f51abc3809a84ca52798274bcfdcb4"
    sha256 cellar: :any_skip_relocation, sonoma:        "6fc2f394002385801b6f689dfcbcd6f57a6253d4a7c0be7cb284c416f91e4f5d"
    sha256 cellar: :any_skip_relocation, ventura:       "c72e8f81c344e865403bab3e53073ec840357bdbde43869f56556696534adfcf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c1f5cd555e3be43a2c9b582eadae65ed0563c41dcf6fd6c29865b401ae784473"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bff9ac8b4c25af12655bf41915b791ad862cab088b26e97ba8383371dc880450"
  end

  depends_on "go"

  def install
    ldflags = "-s -w -X main.version=#{version} -X main.commit=#{tap.user}"
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"vet", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/vet version 2>&1")

    output = shell_output("#{bin}/vet scan parsers 2>&1")
    assert_match "Available Lockfile Parsers", output
  end
end
