apiVersion: apps/v1
kind: Deployment
metadata:
  name: snake-game
  namespace: snake-game
  labels:
    app: snake-game
spec:
  replicas: 1
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxUnavailable: 1
      maxSurge: 1
  selector:
    matchLabels:
      app: snake-game
  template:
    metadata:
      labels:
        app: snake-game
    spec:
      terminationGracePeriodSeconds: 30
      containers:
        - name: snake-game
          image: npandeya/snake-app:${IMAGE_TAG}
          imagePullPolicy: IfNotPresent
          ports:
            - containerPort: 80
          resources:
            requests:
              memory: "256Mi"
              cpu: "250m"
            limits:
              memory: "512Mi"
              cpu: "500m"
          livenessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 3
            periodSeconds: 5
          readinessProbe:
            httpGet:
              path: /
              port: 80
            initialDelaySeconds: 2
            periodSeconds: 5
