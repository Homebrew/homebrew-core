class Shml < Formula
  desc "Style Framework for The Terminal"
  homepage "https://odb.github.io/shml/"
  url "https://github.com/odb/shml/archive/1.1.0.tar.gz"
  sha256 "0f0634fe5dd043f5ff52946151584a59b5826acbb268c9d884a166c3196b8f4f"
  license "MIT"

  bottle :unneeded

  def install
    bin.install "shml.sh"
    bin.install_symlink bin/"shml.sh" => "shml"
  end

  test do
    ["shml", "shml.sh"].each do |cmd|
      result = shell_output("#{bin}/#{cmd} -v")
      result.force_encoding("UTF-8") if result.respond_to?(:force_encoding)
      assert_match version.to_s, result
    end
  end
end
