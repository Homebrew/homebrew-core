class Swctl < Formula
  desc "SiteWhere Control CLI"
  homepage "https://sitewhere.io/"
  url "https://github.com/sitewhere/swctl.git",
      tag:      "v0.4.2",
      revision: "22227b0c66bf5981a775f4cd7eb91676de53472d"
  license "Apache-2.0"
  head "https://github.com/sitewhere/swctl.git"

  depends_on "go" => :build

  def install
    system "make", "build"
    bin.install "bin/swctl"
  end

  test do
    system "#{bin}/swctl", "version"
    assert_predicate testpath/"bin/swctl", :exist?
  end
end
