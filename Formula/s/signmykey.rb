class Signmykey < Formula
  desc "Automated SSH Certificate Authority"
  homepage "https://signmykey.io"
  url "https://github.com/signmykeyio/signmykey/archive/refs/tags/v0.8.7.tar.gz"
  sha256 "d9697c1d289280395188caaa8b2e10a23cc4c94ca33a493ae398c3a6be500155"
  license "MIT"
  head "https://github.com/signmykeyio/signmykey.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "df182eaf64241a92448d5810f08442fc0cba432e9e29e176dafe84d80f35c4ab"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "ff65fdb76925458ec0c53567cff1b0458f0d62257e69fe2b014fc50a91566335"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a826af57759023e9b57e6e4401c47e9b49b6c3f442a85d806c751554fce0c5d9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d42cd9fc8f60f8e2a602a50f425d1e384c8c50dfd2724a59c38912e171ad0683"
    sha256 cellar: :any_skip_relocation, sonoma:         "03fbaf48b6ca79e26781e669986ce031c78d0b6af4d7445f6da63365ff3054c6"
    sha256 cellar: :any_skip_relocation, ventura:        "920fe34b74df9c70fe6bc87ff58892d4607d4a6a6f49f710e87dff7f6e9b4461"
    sha256 cellar: :any_skip_relocation, monterey:       "92804d80c023e5b070a98582c3a3c52a7c4722e8956a1663926a0e9216b61e8e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "88d4ae72b3b6068fa679a8daf35b7770fb18295aa5326f3829f9902c43d88bab"
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s -w
      -X github.com/signmykeyio/signmykey/cmd.versionString=#{version}
    ]
    system "go", "build", *std_go_args(ldflags:)

    generate_completions_from_executable(bin/"signmykey", "completion")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/signmykey version")

    require "pty"
    stdout, _stdin, _pid = PTY.spawn("#{bin}/signmykey server dev -u myremoteuser")
    sleep 2
    assert_match "Starting signmykey server in DEV mode", stdout.readline
  end
end
