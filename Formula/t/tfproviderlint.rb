class Tfproviderlint < Formula
  desc "Terraform Provider Lint Tool"
  homepage "https://github.com/bflad/tfproviderlint"
  url "https://github.com/bflad/tfproviderlint/archive/refs/tags/v0.30.0.tar.gz"
  sha256 "c62be00c7745ae6d2662e09df9d2192d73c4062a765a596b4ff4fc5bb54c956e"
  license "MPL-2.0"
  head "https://github.com/bflad/tfproviderlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "899b4934ed99c3cfaa213808c2122a7041fd05fddd7a1a5ffae477eb51b391bc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0c2c25e4b2784edc72ad3b250a15a1770b75be362bc7a852efbc39f19fc158b0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0c2c25e4b2784edc72ad3b250a15a1770b75be362bc7a852efbc39f19fc158b0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0c2c25e4b2784edc72ad3b250a15a1770b75be362bc7a852efbc39f19fc158b0"
    sha256 cellar: :any_skip_relocation, sonoma:         "64f4d0cb403a4faa50f652c61def6d45002c2d0ce5788bf05d39eddd4c653eb1"
    sha256 cellar: :any_skip_relocation, ventura:        "64f4d0cb403a4faa50f652c61def6d45002c2d0ce5788bf05d39eddd4c653eb1"
    sha256 cellar: :any_skip_relocation, monterey:       "64f4d0cb403a4faa50f652c61def6d45002c2d0ce5788bf05d39eddd4c653eb1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e77634c400b92b99188b9b09682daac604a1aa16fdf712ca16652e7d7c4679e5"
  end

  depends_on "go" => [:build, :test]

  def install
    ldflags = %W[
      -s -w
      -X github.com/bflad/tfproviderlint/version.Version=#{version}
      -X github.com/bflad/tfproviderlint/version.VersionPrerelease=#{build.head? ? "dev" : ""}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tfproviderlint"
  end

  test do
    resource "homebrew-test_resource" do
      url "https://github.com/russellcardullo/terraform-provider-pingdom/archive/refs/tags/v1.1.3.tar.gz"
      sha256 "3834575fd06123846245eeeeac1e815f5e949f04fa08b65c67985b27d6174106"
    end

    testpath.install resource("homebrew-test_resource")
    assert_match "S006: schema of TypeMap should include Elem",
      shell_output(bin/"tfproviderlint -fix #{testpath}/... 2>&1", 3)

    assert_match version.to_s, shell_output(bin/"tfproviderlint --version")
  end
end
