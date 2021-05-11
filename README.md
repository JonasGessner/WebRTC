# WebRTC for Darwin

### Setup

- Follow the usual instructions to set up a WebRTC build environment: [https://webrtc.github.io/webrtc-org/native-code/ios/]()
- Once set up, `cd` to the `src` folder (which is a git checkout) and add this repository as a new remote
- Fetch from the remote and switch to the branch `scion`
- `Run ./build.sh`

--------------------------

**WebRTC is a free, open software project** that provides browsers and mobile
applications with Real-Time Communications (RTC) capabilities via simple APIs.
The WebRTC components have been optimized to best serve this purpose.

**Our mission:** To enable rich, high-quality RTC applications to be
developed for the browser, mobile platforms, and IoT devices, and allow them
all to communicate via a common set of protocols.

The WebRTC initiative is a project supported by Google, Mozilla and Opera,
amongst others.

### Development

See [here][native-dev] for instructions on how to get started
developing with the native code.

[Authoritative list](native-api.md) of directories that contain the
native API header files.

### More info

 * Official web site: http://www.webrtc.org
 * Master source code repo: https://webrtc.googlesource.com/src
 * Samples and reference apps: https://github.com/webrtc
 * Mailing list: http://groups.google.com/group/discuss-webrtc
 * Continuous build: https://ci.chromium.org/p/webrtc/g/ci/console
 * [Coding style guide](style-guide.md)
 * [Code of conduct](CODE_OF_CONDUCT.md)
 * [Reporting bugs](docs/bug-reporting.md)

[native-dev]: https://webrtc.googlesource.com/src/+/refs/heads/master/docs/native-code/index.md
