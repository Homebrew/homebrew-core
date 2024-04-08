class Seclists < Formula
  desc "Essential for security testing, offering diverse lists for assessments"
  homepage "https://github.com/danielmiessler/SecLists"
  url "https://github.com/danielmiessler/SecLists"
  version "2024.1"
  sha256 "da0a9314cde32c67622c8030e846f94461e6c2ccaff5f529ee066e898097bd82"
  license "MIT"

  def install
    mkdir "#{prefix}/seclists"
    share.install_symlink "#{prefix}/seclists"
    ohai "Size of a complete clone of SecLists is currently at 1.2 GB"
    ohai "Cloning this repository should take 4-5 minutes at 5MB/s speeds."
    system "git", "clone", "git@github.com:danielmiessler/SecLists.git", "#{prefix}/seclists"
  end

  test do
    # test if there are files in the directory /opt/homebrew/Cellar/seclists/2024.1/seclists
    assert_predicate prefix/"seclists", :exist?

    # test if the link is created
    assert_predicate HOMEBREW_PREFIX/"share/seclists", :exist?
  end
end
