class Wskdeploy < Formula
  desc "Apache OpenWhisk project deployment utility"
  homepage "https://openwhisk.apache.org/"
  url "https://github.com/apache/openwhisk-wskdeploy/archive/refs/tags/1.2.0.tar.gz"
  sha256 "bffe6f6ef2167189fc38893943a391aaf7327e9e6b8d27be1cc1c26535c06e86"
  license "Apache-2.0"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:    "b62f6e49c4bc8484a1da38511cef47eff090660658b6b284d0a75c0f2b00adcd"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "0c0e4b40c6a0e7f4a5b07424402fcade78732f3c3c9b190ed6c603a3172044db"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "dee1aeb56b815b07c277e5e74954c803135b729586eaf82cc78365494a3909e5"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08cf43fae8646a2da12684d40c5271ea647950788125e7e896d5641984ec98f4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4b42f8375e4d73e6fc92323e40b2c12f98227b4293e0e948cdfc514e698207fe"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "87364286a37d26de6a051ba1d0244de932de11058e041e969ea20400560df8e5"
    sha256 cellar: :any_skip_relocation, sonoma:         "7cff7f54d9f9a600e9f8871f921f105b2ceebef547433f39dbf9c13529519a60"
    sha256 cellar: :any_skip_relocation, ventura:        "9a5292f9f476d5fcde994572952c3e1c454367e0a95ec6ac13e416eb37eede43"
    sha256 cellar: :any_skip_relocation, monterey:       "e3d3c61f5b230af2a2a5776448d06985cee14f9c7aa5b51dc40179922d655df1"
    sha256 cellar: :any_skip_relocation, big_sur:        "c77d6ad2c5fa8acec45bf9507d840f3de1a125edb5759f6de49427efb454fd38"
    sha256 cellar: :any_skip_relocation, catalina:       "17ff44da88c60d8c8c3a17fd4e2844c90d1bf7fe460928ae21731da5a7f52740"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "64612b924eacd2f375233837be737190dce67172247069d910ca354dd00c60b0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "eabf999a20dc7a3ce1b521b85e4a60731b740413ea133e5299ea534b0c44764a"
  end

  depends_on "go" => :build

  def install
    ldflags = "-s -w -X main.Version=#{version}"
    system "go", "build", *std_go_args(ldflags:)
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/wskdeploy version")

    (testpath/"manifest.yaml").write <<~YAML
      packages:
        hello_world_package:
          version: 1.0
          license: Apache-2.0
    YAML

    system bin/"wskdeploy", "-v",
                            "--apihost", "openwhisk.ng.bluemix.net",
                            "--preview",
                            "-m", testpath/"manifest.yaml",
                            "-u", "abcd"
  end
end
