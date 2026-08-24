class Tfproviderlint < Formula
  desc "Terraform Provider Lint Tool"
  homepage "https://github.com/bflad/tfproviderlint"
  url "https://github.com/bflad/tfproviderlint/archive/refs/tags/v0.31.0.tar.gz"
  sha256 "9defa750077052ebf1639532e771a9e986b7a53948b6a16cb647ceaf60cfbce1"
  license "MPL-2.0"
  revision 1
  head "https://github.com/bflad/tfproviderlint.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "41e55bedd7227335e6654821fcd14e582d8c48514d8df62a9136a8ef15028d90"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "41e55bedd7227335e6654821fcd14e582d8c48514d8df62a9136a8ef15028d90"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "41e55bedd7227335e6654821fcd14e582d8c48514d8df62a9136a8ef15028d90"
    sha256 cellar: :any_skip_relocation, sonoma:        "dfb3b76521fab5b8f81c927e117b1029e48d830268433ac124dabf2df75a6cab"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51b3c2e54371787e3a07785b27add80eddd91c96cdb7d1c96b7d46b294b7f319"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ecd9538961f5f67ce00b6249b89fc0e73c132300b0ca9a19e3eb62d10d727fdd"
  end

  # TODO: unpin go@1.26 when tfproviderlint supports go 1.27
  # ref: https://github.com/bflad/tfproviderlint/issues/345
  depends_on "go@1.26" => [:build, :test]

  def install
    ldflags = %W[
      -X github.com/bflad/tfproviderlint/version.Version=#{version}
      -X github.com/bflad/tfproviderlint/version.VersionPrerelease=#{"dev" if build.head?}
    ]

    system "go", "build", *std_go_args(ldflags:), "./cmd/tfproviderlint"
  end

  test do
    resource "homebrew-test_resource" do
      url "https://github.com/russellcardullo/terraform-provider-pingdom/archive/refs/tags/v1.1.3.tar.gz"
      sha256 "3834575fd06123846245eeeeac1e815f5e949f04fa08b65c67985b27d6174106"
    end

    # TODO: remove when unpinning go 1.26
    ENV.prepend_path "PATH", formula_opt_libexec("go@1.26")/"bin" # for keg_only go 1.26 binary

    testpath.install resource("homebrew-test_resource")
    assert_match "S006: schema of TypeMap should include Elem",
      shell_output("#{bin}/tfproviderlint -fix #{testpath}/... 2>&1", 3)

    assert_match version.to_s, shell_output("#{bin}/tfproviderlint --version")
  end
end
