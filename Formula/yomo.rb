class Yomo < Formula
  desc "Streaming Serverless Framework for Low-latency edge computing applications"
  homepage "https://yomo.run"
  url "https://github.com/yomorun/yomo/archive/v0.5.0.tar.gz"
  sha256 "d7180d867837af03d53ee0f50e04ae09c56f60574d8a29afd3244c66300f9c5a"
  license "Apache-2.0"

  depends_on "go"

  def install
    ENV["YOMO_VERSION"] = version.to_s
    system "make", "build"
    bin.install "bin/yomo"
  end

  test do
    (testpath/"app.go").write <<~EOS
      package main

      import (
        "context"
        "fmt"
        "time"

        "github.com/yomorun/yomo/pkg/rx"
      )

      var printer = func(_ context.Context, i interface{}) (interface{}, error) {
        value := i.(float32)
        fmt.Println("serverless get value:", value)
        return value, nil
      }

      // Handler will handle data in Rx way
      func Handler(rxstream rx.RxStream) rx.RxStream {
        stream := rxstream.
          Y3Decoder("0x10", float32(0)).
          AuditTime(100 * time.Millisecond).
          Map(printer).
          StdOut()

        return stream
      }

    EOS
    system bin/"yomo build"
    assert_predicate testpath/"sl.so", :exist?
    assert_match "yomo version #{version}", shell_output("#{bin}/yomo version")
  end
end
