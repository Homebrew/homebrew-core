class Qdated < Formula
  desc "Create and verify timestamped email addresses for qmail"
  homepage "https://web.archive.org/web/www.palomine.net/qdated/"
  url "https://web.archive.org/web/www.palomine.net/qdated/qdated-0.53.tar.gz"
  sha256 "002391c656c705838965cab8231261f2474b26711c03e24cf0ecf2978b3cf934"

  def install
    Dir.chdir("qdated-#{version}") do
      system "package/compile"
    end

    bin.install "qdated-#{version}/command/qdated-check"
    bin.install "qdated-#{version}/command/qdated-makekey"
    bin.install "qdated-#{version}/command/qdated-now"

    File.rename "qdated-#{version}/package/LICENSE", "LICENSE"
  end

  test do
    require "English"

    system "qdated-makekey"
    assert_predicate testpath/".qdated-key", :exist?

    now = `qdated-now`

    output = `DEFAULT=#{now} qdated-check 10 2>&1`
    assert_equal "qdated-check: info: Address is valid and hasn't expired.\n", output
    assert_equal 0, $CHILD_STATUS.exitstatus

    File.delete testpath/".qdated-key"
    system "qdated-makekey"

    output = `DEFAULT=#{now} qdated-check 10 2>&1`
    assert_equal "qdated-check: info: This address is invalid.\n", output
    assert_equal 100, $CHILD_STATUS.exitstatus
  end
end
