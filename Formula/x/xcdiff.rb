class Xcdiff < Formula
  desc "Tool to diff xcodeproj files"
  homepage "https://github.com/bloomberg/xcdiff"
  url "https://github.com/bloomberg/xcdiff.git",
      tag:      "0.13.0",
      revision: "99301ee4578224f0660a1312abc465c5a37176c5"
  license "Apache-2.0"
  head "https://github.com/bloomberg/xcdiff.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bd62e3b0b02971f946bea613e95a4ceeb8ab41ede5383518148c542b5908ef04"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "350423748bd984e66f473e60a4545125870b8589807b8d82b01745e0a45cad50"
    sha256 cellar: :any,                 arm64_ventura: "2ba598baf440f1a76a105f07489776c4e81a1a1803d49c396209e88599e20410"
    sha256 cellar: :any_skip_relocation, sonoma:        "23083c0664be219b75633a64827762ea19a078b11d76558336df3c82928312e3"
    sha256 cellar: :any,                 ventura:       "fa904d1ebca63b4ba8e032e8406279535f91bc0f6e62a94edec04ce1f4123950"
  end

  depends_on :macos

  uses_from_macos "swift" => :build, since: :sonoma # swift 5.10+

  def install
    system "make", "update_version"
    system "make", "update_hash"
    system "swift", "build", "--disable-sandbox", "--configuration", "release"
    bin.install ".build/release/xcdiff"
  end

  test do
    resource "homebrew-testdata" do
      url "https://github.com/bloomberg/xcdiff/archive/refs/tags/0.10.0.tar.gz"
      sha256 "c093e128873f1bb2605b14bf9100c5ad7855be17b14f2cad36668153110b1265"
    end

    assert_match version.to_s, shell_output("#{bin}/xcdiff --version").chomp
    project = "Fixtures/ios_project_1/Project.xcodeproj"
    diff_args = "-p1 #{project} -p2 #{project}"
    resource("homebrew-testdata").stage do
      # assert no difference between projects
      assert_equal "\n", shell_output("#{bin}/xcdiff #{diff_args} -d")
      out = shell_output("#{bin}/xcdiff #{diff_args} -g BUILD_PHASES -t Project -v")
      assert_match "✅ BUILD_PHASES > \"Project\" target\n", out
    end
  end
end
