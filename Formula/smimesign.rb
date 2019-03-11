class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/0.0.10.tar.gz"
  sha256 "c2036abba5f38b42acc40f311176a7af0bef7f9cc4f6c0454ba51d2335631db3"

  bottle do
    cellar :any_skip_relocation
    sha256 "da64d72469542b9f414f755030d0f7367d86239f74a80a67ab280f8e2e792c3a" => :mojave
    sha256 "3651001471f346165ad493458c46629ff8ba7395a6610217941cdb4634c7b84b" => :high_sierra
    sha256 "2e4c7a707f083376c7ea4e2e659576de4ffde7252327c882516671e35530e40b" => :sierra
  end

  depends_on "go" => :build
  depends_on :macos => :sierra

  def install
    ENV["GOPATH"] = buildpath
    (buildpath/"src/github.com/github/smimesign").install buildpath.children

    cd "src/github.com/github/smimesign" do
      system "go", "build", "-o", bin/"smimesign", "-ldflags", "-X main.versionString=#{version}"
      prefix.install_metafiles
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/smimesign --version")
    system "#{bin}/smimesign", "--list-keys"
    assert_match "could not find identity matching specified user-id: bad@identity", shell_output("#{bin}/smimesign -su bad@identity 2>&1", 1)
  end
end
