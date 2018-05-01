class Stm32flash < Formula
  desc "Open source flash program for STM32 using the ST serial bootloader"
  homepage "https://sourceforge.net/projects/stm32flash/"
  url "https://downloads.sourceforge.net/project/stm32flash/stm32flash-0.5.tar.gz"
  sha256 "97aa9422ef02e82f7da9039329e21a437decf972cb3919ad817f70ac9a49e306"

  expected_err = <<~EOF
    Error probing interface "serial_posix"
    Cannot handle device "/dev/tty.XYZ"
    Failed to open port: /dev/tty.XYZ
  EOF
  expected_out = <<~EOF
    stm32flash #{version}

    http://stm32flash.sourceforge.net/


  EOF

  def install
    system "make", "PREFIX=#{prefix}", "install"
  end

  test do
    system "#{bin}/stm32flash", "-h"

    require "open3"
    Open3.popen3("#{bin}/stm32flash", "-k", "/dev/tty.XYZ") do |_, stdout, stderr, wait_thr|
      assert_equal expected_out, stdout.read
      assert_equal expected_err, stderr.read
      assert_equal 1, wait_thr.value.exitstatus
    end
  end
end
