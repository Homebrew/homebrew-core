class Traeger < Formula
  desc "Portable Actor System for C++"
  homepage "https://github.com/tigrux/traeger"
  url "https://github.com/tigrux/traeger/archive/refs/tags/v0.1.0.tar.gz"
  sha256 "c436e0deed9d64d0aa91ac8eaa4429e844529de9ba3a025f5c3137b848da274c"
  license "BSL-1.0"

  depends_on "catch2" => :build
  depends_on "cmake" => :build
  depends_on "cppzmq" => :build
  depends_on "immer" => :build
  depends_on "msgpack-cxx" => :build
  depends_on "nlohmann-json" => :build
  depends_on "yaml-cpp"
  depends_on "zeromq"

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_INSTALL_RPATH=#{rpath}", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    (testpath / "test.cpp").write <<~CPP
      #include <cassert>
      #include <future>
      #include <traeger/actor/Actor.hpp>

      class User
      {
      private:
          std::string name_;

      public:
          User(const std::string &name)
              : name_(name)
          {
          }

          std::string get_name() const
          {
              return name_;
          }

          void set_name(std::string name)
          {
              name_ = name;
          }
      };

      int main()
      {
          using namespace traeger;
          const auto scheduler = Scheduler{Threads{8}};
          const auto actor = make_actor<User>("John");
          actor.define("get_name", &User::get_name);
          actor.define("set_name", &User::set_name);
          const auto mailbox = actor.mailbox();
          {
              auto promise = std::promise<Value>{};
              mailbox.send(scheduler, "get_name")
                  .then(
                      [&promise](const Value &value)
                      {
                          promise.set_value(value);
                      });
              assert(promise.get_future().get() == "John");
          }
          {
              auto promise = std::promise<Value>{};
              mailbox.send(scheduler, "set_name", "Jack");
              mailbox
                  .send(scheduler, "get_name")
                  .then(
                      [&promise](const Value &value)
                      {
                          promise.set_value(value);
                      });
              assert(promise.get_future().get() == "Jack");
          }
      }
    CPP
    system ENV.cxx,
      "-std=c++17", "test.cpp",
      "-I#{include}", "-L#{lib}",
      "-ltraeger_value", "-ltraeger_actor",
      "-o", "test"
    system "./test"
  end
end
