// Copyright 2018 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';

abstract class Pagee extends StatelessWidget {
  const Pagee(this.leading, this.title);

  final Widget leading;
  final String title;
}
