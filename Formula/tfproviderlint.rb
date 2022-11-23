class Tfproviderlint < Formula
  desc "Terraform Provider Lint Tool"
  homepage "https://github.com/bflad/tfproviderlint"
  url "https://github.com/bflad/tfproviderlint/archive/v0.28.1.tar.gz"
  sha256 "df66a164256ffbacbb260e445313c0666bb14ce4b8363f123903259ecc0f4eb5"
  license "MPL-2.0"
  revision 1
  head "https://github.com/bflad/tfproviderlint.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd36003e58d30dadaea71799a395ba6b6e351eec59ba2327b8e7578f46496ace"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0b15d7545d090d848ea12f981fe19a1671c2deba219ce0a3dc216e9f781fd329"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0b15d7545d090d848ea12f981fe19a1671c2deba219ce0a3dc216e9f781fd329"
    sha256 cellar: :any_skip_relocation, ventura:        "e09b93dbbacd69092e3b3a69fbd6ea34101224c2eb99332d643c18e1a95081dd"
    sha256 cellar: :any_skip_relocation, monterey:       "5d9d0e0daed9c55ab38aceabebd89421d61cf56e600185189fa126941497f149"
    sha256 cellar: :any_skip_relocation, big_sur:        "5d9d0e0daed9c55ab38aceabebd89421d61cf56e600185189fa126941497f149"
    sha256 cellar: :any_skip_relocation, catalina:       "5d9d0e0daed9c55ab38aceabebd89421d61cf56e600185189fa126941497f149"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "76c181e440e93dca6784ff49c7592f2a039ba64785220c7f9eb66bdc73f3273a"
  end

  depends_on "go@1.17" => [:build, :test]

  resource "test_resource" do
    url "https://github.com/russellcardullo/terraform-provider-pingdom/archive/v1.1.3.tar.gz"
    sha256 "3834575fd06123846245eeeeac1e815f5e949f04fa08b65c67985b27d6174106"
  end

  def install
    ENV["CGO_ENABLED"] = "0"

    ldflags = %W[
      -s -w
      -X github.com/bflad/tfproviderlint/version.Version=#{version}
    ]

    ldflags << if build.head?
      "-X github.com/bflad/tfproviderlint/version.VersionPrerelease=dev"
    else
      "-X github.com/bflad/tfproviderlint/version.VersionPrerelease="
    end

    output = libexec/"bin/tfproviderlint"
    system "go", "build", *std_go_args(ldflags: ldflags.join(" "), output: output), "./cmd/tfproviderlint"
    (bin/"tfproviderlint").write_env_script(output, PATH: "$PATH:#{Formula["go@1.17"].opt_bin}")
  end

  test do
    testpath.install resource("test_resource")
    assert_match "S006: schema of TypeMap should include Elem",
      shell_output(bin/"tfproviderlint -fix #{testpath}/... 2>&1", 3)

    assert_match version.to_s, shell_output(bin/"tfproviderlint --version")
  end
end
