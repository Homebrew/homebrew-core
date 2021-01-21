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
<<<<<<< HEAD
    version_output = shell_output("#{bin}/swctl version 2>&1")
    assert_match "Version:\"v#{version}\"", version_output
=======
    system "#{bin}/swctl", "version"
    assert_predicate testpath/"bin/swctl", :exist?
>>>>>>> 81c54604b31d2a5e9594d77ae4078496198c92c2
  end
end
