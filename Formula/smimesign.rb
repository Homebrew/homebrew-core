class Smimesign < Formula
  desc "S/MIME signing utility for use with Git"
  homepage "https://github.com/github/smimesign"
  url "https://github.com/github/smimesign/archive/0.0.3.tar.gz"
  sha256 "69dfa16737c715679e067d0d929dd964790060b33981695d71bd6b047ae64e97"

  bottle do
    cellar :any_skip_relocation
    sha256 "9ad7ba446a3a48d463eacab9335c76b81edaa1f5712dc86de783d7bba99ca5d3" => :mojave
    sha256 "6430de59344c81a0ff4d45769d3b4920bb926814d948123d1b8a1b7db640c9a2" => :high_sierra
    sha256 "368bb35bcedfa1576518f9e64ad3d045e61f44ac5c2fd620e9833bc9d996b08e" => :sierra
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
