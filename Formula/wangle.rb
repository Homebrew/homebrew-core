class Wangle < Formula
  desc "Framework providing a set of common client/server abstractions"
  homepage "https://github.com/facebook/wangle"
  url "https://github.com/facebook/wangle/archive/v2017.12.25.00.tar.gz"
  sha256 "02abb153bc5be63a82d39fd4af879a09915ea2093412c749c86f878816ad0184"

  depends_on "cmake" => :build
  depends_on "folly"
  depends_on "gflags"
  depends_on "glog"
  depends_on "openssl"

  def install
    cd "wangle" do
      system "cmake", ".", *std_cmake_args
      system "make", "install"
    end
  end

  test do
    (testpath/"EchoServer.cpp").write <<~EOS
      /*
       * Copyright 2017-present Facebook, Inc.
       *
       * Licensed under the Apache License, Version 2.0 (the "License");
       * you may not use this file except in compliance with the License.
       * You may obtain a copy of the License at
       *
       *   http://www.apache.org/licenses/LICENSE-2.0
       *
       * Unless required by applicable law or agreed to in writing, software
       * distributed under the License is distributed on an "AS IS" BASIS,
       * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       * See the License for the specific language governing permissions and
       * limitations under the License.
       */
      #include <gflags/gflags.h>

      #include <wangle/bootstrap/ServerBootstrap.h>
      #include <wangle/channel/AsyncSocketHandler.h>
      #include <wangle/codec/LineBasedFrameDecoder.h>
      #include <wangle/codec/StringCodec.h>

      using namespace folly;
      using namespace wangle;

      DEFINE_int32(port, 8080, "echo server port");

      typedef Pipeline<IOBufQueue&, std::string> EchoPipeline;

      // the main logic of our echo server; receives a string and writes it straight
      // back
      class EchoHandler : public HandlerAdapter<std::string> {
       public:
        void read(Context* ctx, std::string msg) override {
          std::cout << "handling " << msg << std::endl;
          write(ctx, msg + "\\r\\n");
        }
      };

      // where we define the chain of handlers for each messeage received
      class EchoPipelineFactory : public PipelineFactory<EchoPipeline> {
       public:
        EchoPipeline::Ptr newPipeline(
            std::shared_ptr<AsyncTransportWrapper> sock) override {
          auto pipeline = EchoPipeline::create();
          pipeline->addBack(AsyncSocketHandler(sock));
          pipeline->addBack(LineBasedFrameDecoder(8192));
          pipeline->addBack(StringCodec());
          pipeline->addBack(EchoHandler());
          pipeline->finalize();
          return pipeline;
        }
      };

      int main(int argc, char** argv) {
        gflags::ParseCommandLineFlags(&argc, &argv, true);

        ServerBootstrap<EchoPipeline> server;
        server.childPipeline(std::make_shared<EchoPipelineFactory>());
        server.bind(FLAGS_port);
        server.waitForStop();

        return 0;
      }
    EOS
    (testpath/"EchoClient.cpp").write <<~EOS
      /*
       * Copyright 2017-present Facebook, Inc.
       *
       * Licensed under the Apache License, Version 2.0 (the "License");
       * you may not use this file except in compliance with the License.
       * You may obtain a copy of the License at
       *
       *   http://www.apache.org/licenses/LICENSE-2.0
       *
       * Unless required by applicable law or agreed to in writing, software
       * distributed under the License is distributed on an "AS IS" BASIS,
       * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
       * See the License for the specific language governing permissions and
       * limitations under the License.
       */
      #include <gflags/gflags.h>
      #include <iostream>

      #include <wangle/bootstrap/ClientBootstrap.h>
      #include <wangle/channel/AsyncSocketHandler.h>
      #include <wangle/channel/EventBaseHandler.h>
      #include <wangle/codec/LineBasedFrameDecoder.h>
      #include <wangle/codec/StringCodec.h>

      using namespace folly;
      using namespace wangle;

      DEFINE_int32(port, 8080, "echo server port");
      DEFINE_string(host, "::1", "echo server address");

      typedef Pipeline<folly::IOBufQueue&, std::string> EchoPipeline;

      // the handler for receiving messages back from the server
      class EchoHandler : public HandlerAdapter<std::string> {
       public:
        void read(Context*, std::string msg) override {
          std::cout << "received back: " << msg;
        }
        void readException(Context* ctx, exception_wrapper e) override {
          std::cout << exceptionStr(e) << std::endl;
          close(ctx);
        }
        void readEOF(Context* ctx) override {
          std::cout << "EOF received :(" << std::endl;
          close(ctx);
        }
      };

      // chains the handlers together to define the response pipeline
      class EchoPipelineFactory : public PipelineFactory<EchoPipeline> {
       public:
        EchoPipeline::Ptr newPipeline(
            std::shared_ptr<AsyncTransportWrapper> sock) override {
          auto pipeline = EchoPipeline::create();
          pipeline->addBack(AsyncSocketHandler(sock));
          pipeline->addBack(
              EventBaseHandler()); // ensure we can write from any thread
          pipeline->addBack(LineBasedFrameDecoder(8192, false));
          pipeline->addBack(StringCodec());
          pipeline->addBack(EchoHandler());
          pipeline->finalize();
          return pipeline;
        }
      };

      int main(int argc, char** argv) {
        gflags::ParseCommandLineFlags(&argc, &argv, true);

        ClientBootstrap<EchoPipeline> client;
        client.group(std::make_shared<folly::IOThreadPoolExecutor>(1));
        client.pipelineFactory(std::make_shared<EchoPipelineFactory>());
        auto pipeline = client.connect(SocketAddress(FLAGS_host, FLAGS_port)).get();

        try {
          while (true) {
            std::string line;
            std::getline(std::cin, line);
            if (line == "") {
              break;
            }

            pipeline->write(line + "\\r\\n").get();
            if (line == "bye") {
              pipeline->close();
              break;
            }
          }
        } catch (const std::exception& e) {
          std::cout << exceptionStr(e) << std::endl;
        }

        return 0;
      }
    EOS
    system ENV.cxx, "-std=c++14",
                    "-I#{Formula["gflags"].include}",
                    "-I#{Formula["glog"].include}",
                    "-I#{Formula["openssl"].include}",
                    "-I#{Formula["folly"].include}",
                    "-I#{Formula["wangle"].include}",
                    "-L#{Formula["gflags"].lib}",
                    "-L#{Formula["glog"].lib}",
                    "-L#{Formula["openssl"].lib}",
                    "-L#{Formula["folly"].lib}",
                    "-L#{Formula["wangle"].lib}",
                    "EchoServer.cpp",
                    "-lgflags", "-lglog", "-lcrypto", "-lssl", "-lfolly", "-lwangle",
                    "-o", "EchoServer"
    system ENV.cxx, "-std=c++14",
                    "-I#{Formula["gflags"].include}",
                    "-I#{Formula["glog"].include}",
                    "-I#{Formula["openssl"].include}",
                    "-I#{Formula["folly"].include}",
                    "-I#{Formula["wangle"].include}",
                    "-L#{Formula["gflags"].lib}",
                    "-L#{Formula["glog"].lib}",
                    "-L#{Formula["openssl"].lib}",
                    "-L#{Formula["folly"].lib}",
                    "-L#{Formula["wangle"].lib}",
                    "EchoClient.cpp",
                    "-lgflags", "-lglog", "-lcrypto", "-lssl", "-lfolly", "-lwangle",
                    "-o", "EchoClient"
  end
end
